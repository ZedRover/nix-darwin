#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/ryan4yin/nix-darwin-kickstarter.git"
DEFAULT_CONFIG="minimal"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."

    if ! command -v nix &> /dev/null; then
        log_error "Nix is not installed. Please install Nix first:"
        echo "curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
        exit 1
    fi

    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Please install Git first."
        exit 1
    fi

    log_success "Prerequisites check passed"
}

backup_current_config() {
    local backup_dir="$HOME/.config/nix-darwin-backup-$(date +%Y%m%d-%H%M%S)"

    if [[ -d "/etc/nix" ]]; then
        log_info "Creating backup of current configuration..."
        mkdir -p "$backup_dir"

        if [[ -f "/etc/nix/nix.conf" ]]; then
            cp "/etc/nix/nix.conf" "$backup_dir/"
        fi

        if [[ -d "$HOME/.nixpkgs" ]]; then
            cp -r "$HOME/.nixpkgs" "$backup_dir/"
        fi

        log_success "Backup created at $backup_dir"
        echo "$backup_dir" > "$HOME/.nix-darwin-backup-location"
    fi
}

clone_or_update_repo() {
    local target_dir="$1"

    if [[ -d "$target_dir" ]]; then
        log_info "Updating existing repository..."
        cd "$target_dir"
        git pull origin main
    else
        log_info "Cloning repository..."
        git clone "$REPO_URL" "$target_dir"
        cd "$target_dir"
    fi

    log_success "Repository ready at $target_dir"
}

validate_config() {
    local config_type="$1"
    local hostname="$2"

    log_info "Validating $config_type configuration..."

    cd "$config_type"

    # Check flake syntax
    if ! nix flake check --no-build; then
        log_error "Flake validation failed"
        return 1
    fi

    # Dry run build
    if ! nix build ".#darwinConfigurations.$hostname.system" --dry-run; then
        log_error "Configuration build validation failed"
        return 1
    fi

    log_success "Configuration validation passed"
}

deploy_config() {
    local config_type="$1"
    local hostname="$2"
    local target_dir="$3"

    cd "$target_dir/$config_type"

    log_info "Deploying $config_type configuration for $hostname..."

    # Check if nix-darwin is already installed
    if command -v darwin-rebuild &> /dev/null; then
        log_info "Using existing nix-darwin installation..."
        darwin-rebuild switch --flake ".#$hostname"
    else
        log_info "Installing nix-darwin and applying configuration..."
        nix run nix-darwin -- switch --flake ".#$hostname"
    fi

    log_success "Configuration deployed successfully!"
}

show_post_deploy_info() {
    local config_type="$1"

    cat << EOF

${GREEN}🎉 Deployment Complete!${NC}

Your nix-darwin configuration ($config_type) has been applied successfully.

${BLUE}Next steps:${NC}
1. Restart your terminal or run: source ~/.zshrc
2. Verify installation: darwin-rebuild check
3. View installed packages: nix-env --query --installed

${BLUE}Common commands:${NC}
- Update configuration: darwin-rebuild switch --flake .#your-hostname
- Rollback changes: sudo nix-env --rollback --profile /nix/var/nix/profiles/system
- Clean up old generations: nix-collect-garbage -d

${BLUE}Backup location:${NC}
$(cat "$HOME/.nix-darwin-backup-location" 2>/dev/null || echo "No backup created")

EOF
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -c, --config TYPE       Configuration type (minimal|rich-demo) [default: minimal]
    -h, --hostname NAME     Hostname for the configuration [default: auto-detect]
    -d, --directory DIR     Target directory [default: \$HOME/nix-darwin-kickstarter]
    --no-backup            Skip creating backup of current configuration
    --dry-run              Validate configuration without applying
    --help                 Show this help message

Examples:
    $0                                          # Deploy minimal config
    $0 -c rich-demo -h my-mac                 # Deploy rich-demo for hostname 'my-mac'
    $0 --dry-run                               # Validate without deploying
EOF
}

main() {
    local config_type="$DEFAULT_CONFIG"
    local hostname=""
    local target_dir="$HOME/nix-darwin-kickstarter"
    local create_backup=true
    local dry_run=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--config)
                config_type="$2"
                shift 2
                ;;
            -h|--hostname)
                hostname="$2"
                shift 2
                ;;
            -d|--directory)
                target_dir="$2"
                shift 2
                ;;
            --no-backup)
                create_backup=false
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Validate config type
    if [[ "$config_type" != "minimal" && "$config_type" != "rich-demo" ]]; then
        log_error "Invalid config type: $config_type. Must be 'minimal' or 'rich-demo'"
        exit 1
    fi

    # Auto-detect hostname if not provided
    if [[ -z "$hostname" ]]; then
        if [[ "$config_type" == "minimal" ]]; then
            hostname="zeds"  # Default from minimal flake.nix
        else
            hostname=$(scutil --get ComputerName | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
            log_warning "Auto-detected hostname: $hostname"
            log_warning "For rich-demo, you may need to update flake.nix with your username"
        fi
    fi

    log_info "Starting nix-darwin deployment"
    log_info "Configuration: $config_type"
    log_info "Hostname: $hostname"
    log_info "Target directory: $target_dir"

    check_prerequisites

    if [[ "$create_backup" == true ]]; then
        backup_current_config
    fi

    clone_or_update_repo "$target_dir"
    validate_config "$config_type" "$hostname"

    if [[ "$dry_run" == true ]]; then
        log_success "Dry run completed successfully. Configuration is valid."
        exit 0
    fi

    deploy_config "$config_type" "$hostname" "$target_dir"
    show_post_deploy_info "$config_type"
}

# Run main function with all arguments
main "$@"