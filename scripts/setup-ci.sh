#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

check_github_cli() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI is not installed. Please install it first:"
        echo "brew install gh"
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI is not authenticated. Please run:"
        echo "gh auth login"
        exit 1
    fi

    log_success "GitHub CLI is ready"
}

setup_repository_secrets() {
    local repo_name="$1"

    log_info "Setting up repository secrets..."

    # Check if secrets already exist
    if gh secret list -R "$repo_name" | grep -q "CACHIX_AUTH_TOKEN"; then
        log_warning "CACHIX_AUTH_TOKEN already exists"
    else
        log_info "Please set up Cachix for better build performance:"
        echo "1. Visit https://app.cachix.org and create an account"
        echo "2. Create a cache named 'nix-darwin-kickstarter'"
        echo "3. Generate an auth token"
        echo "4. Run: gh secret set CACHIX_AUTH_TOKEN -R $repo_name"
        log_warning "Skipping CACHIX_AUTH_TOKEN setup (optional)"
    fi

    log_success "Repository secrets setup completed"
}

enable_github_features() {
    local repo_name="$1"

    log_info "Enabling GitHub repository features..."

    # Enable GitHub Actions
    gh api "repos/$repo_name" --method PATCH --field has_discussions=true
    gh api "repos/$repo_name" --method PATCH --field has_projects=true
    gh api "repos/$repo_name" --method PATCH --field has_wiki=true

    # Enable vulnerability alerts
    gh api "repos/$repo_name/vulnerability-alerts" --method PUT || log_warning "Could not enable vulnerability alerts"

    # Enable automated security fixes
    gh api "repos/$repo_name/automated-security-fixes" --method PUT || log_warning "Could not enable automated security fixes"

    log_success "GitHub features enabled"
}

setup_branch_protection() {
    local repo_name="$1"
    local branch="main"

    log_info "Setting up branch protection for $branch..."

    # Create branch protection rule
    gh api "repos/$repo_name/branches/$branch/protection" \
        --method PUT \
        --field required_status_checks='{"strict":true,"checks":[{"context":"Validate Minimal Configuration","app_id":15368},{"context":"Validate Rich Demo Configuration","app_id":15368},{"context":"Security Scan","app_id":15368},{"context":"Lint and Format Check","app_id":15368}]}' \
        --field enforce_admins=false \
        --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true,"require_code_owner_reviews":false}' \
        --field restrictions=null \
        --field allow_force_pushes=false \
        --field allow_deletions=false || {
        log_warning "Could not set up branch protection (may require admin access)"
    }

    log_success "Branch protection setup completed"
}

create_issue_templates() {
    local templates_dir=".github/ISSUE_TEMPLATE"

    log_info "Creating issue templates..."

    mkdir -p "$templates_dir"

    cat > "$templates_dir/bug_report.md" << 'EOF'
---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Run command '...'
2. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Environment (please complete the following information):**
- OS: [e.g. macOS 14.0]
- Nix version: [e.g. 2.18.1]
- nix-darwin version: [e.g. 25.05]
- Configuration: [minimal/rich-demo]

**Additional context**
Add any other context about the problem here.

**Logs**
```
Paste relevant logs here
```
EOF

    cat > "$templates_dir/feature_request.md" << 'EOF'
---
name: Feature request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
EOF

    cat > "$templates_dir/config.yml" << 'EOF'
blank_issues_enabled: false
contact_links:
  - name: Community Support
    url: https://github.com/ryan4yin/nixos-and-flakes-book/discussions
    about: Please ask and answer questions here
  - name: Nix Darwin Documentation
    url: https://daiderd.com/nix-darwin/
    about: Official nix-darwin documentation
EOF

    log_success "Issue templates created"
}

create_pull_request_template() {
    log_info "Creating pull request template..."

    mkdir -p ".github"

    cat > ".github/pull_request_template.md" << 'EOF'
## Description
Brief description of the changes in this PR.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Configuration update

## Configuration Tested
- [ ] Minimal configuration
- [ ] Rich demo configuration
- [ ] Custom configuration

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have tested my changes locally
- [ ] My changes generate no new warnings
- [ ] Any dependent changes have been merged and published

## Additional Notes
Add any additional information about the PR here.
EOF

    log_success "Pull request template created"
}

show_setup_summary() {
    cat << EOF

${GREEN}🎉 CI/CD Setup Complete!${NC}

Your nix-darwin project now has a complete CI/CD pipeline with:

${BLUE}✅ GitHub Actions Workflows:${NC}
  - Automated validation for both minimal and rich-demo configurations
  - Security scanning with Trivy
  - Code formatting and linting checks
  - Automatic deployment notifications
  - Dependabot for dependency updates

${BLUE}✅ Repository Features:${NC}
  - Branch protection on main branch
  - Issue and PR templates
  - Automated security alerts
  - Discussions and wiki enabled

${BLUE}✅ Deployment Tools:${NC}
  - Automated deployment script (scripts/deploy.sh)
  - Backup and rollback capabilities
  - Configuration validation

${BLUE}📝 Next Steps:${NC}
1. Push these changes to your repository
2. Set up Cachix for better build performance (optional)
3. Customize the configurations for your needs
4. Test the CI/CD pipeline with a PR

${BLUE}🚀 Quick Deploy Command:${NC}
  ./scripts/deploy.sh --config minimal

EOF
}

main() {
    local repo_name=""

    # Get repository name
    if git rev-parse --git-dir > /dev/null 2>&1; then
        repo_name=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || echo "")
    fi

    if [[ -z "$repo_name" ]]; then
        log_error "Could not determine repository name. Make sure you're in a git repository and have GitHub CLI configured."
        exit 1
    fi

    log_info "Setting up CI/CD for repository: $repo_name"

    check_github_cli
    setup_repository_secrets "$repo_name"
    enable_github_features "$repo_name"
    setup_branch_protection "$repo_name"
    create_issue_templates
    create_pull_request_template

    show_setup_summary
}

main "$@"