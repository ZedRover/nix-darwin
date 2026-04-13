# Contributing to Nix Darwin Kickstarter

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## 🚀 Development Process

We use GitHub to host code, track issues and feature requests, and accept pull requests.

### Pull Request Process

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our coding standards
3. **Test your changes** thoroughly:
   ```bash
   # Validate configuration
   ./scripts/deploy.sh --dry-run

   # Test both configurations
   cd minimal && nix flake check
   cd ../rich-demo && nix flake check
   ```
4. **Update documentation** if you've changed APIs or added features
5. **Ensure the CI/CD pipeline passes** - all checks must be green
6. **Submit a pull request** with a clear description of changes

### Branch Naming

Use descriptive branch names:
- `feature/add-homebrew-support`
- `fix/flake-validation-error`
- `docs/update-installation-guide`
- `security/fix-dependency-vulnerability`

## 🧪 Testing

### Local Testing

Before submitting a PR, ensure your changes work:

```bash
# Test minimal configuration
cd minimal
nix flake check --no-build
nix build .#darwinConfigurations.zeds.system --dry-run

# Test rich-demo configuration
cd ../rich-demo
nix flake check --no-build
# Update hostname/username for testing
nix build .#darwinConfigurations.test-host.system --dry-run
```

### CI/CD Testing

Our automated pipeline tests:
- ✅ Configuration validation for both templates
- 🔒 Security vulnerability scanning
- 🧹 Code formatting and linting
- 📦 Dependency compatibility

## 📝 Coding Standards

### Nix Code Style

- Use **2 spaces** for indentation
- Follow the existing code style in the project
- Use meaningful variable and function names
- Add comments for complex configurations
- Format code with: `nix fmt`

### Documentation

- Update README.md for significant changes
- Use clear, concise language
- Include code examples where helpful
- Document any new configuration options

### Commit Messages

Follow conventional commits format:

```
type(scope): description

feat(apps): add support for VS Code extensions
fix(system): resolve Dock preferences issue
docs(readme): update installation instructions
ci(actions): add security scanning workflow
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `ci`: CI/CD changes
- `chore`: Maintenance tasks

## 🐛 Bug Reports

Great bug reports tend to have:

- **Clear summary** of the issue
- **Detailed reproduction steps**
- **Expected vs actual behavior**
- **Environment information**:
  - macOS version
  - Nix version
  - nix-darwin version
  - Configuration type (minimal/rich-demo)
- **Error logs** (if applicable)

Use our [bug report template](.github/ISSUE_TEMPLATE/bug_report.md) when filing issues.

## 💡 Feature Requests

We welcome feature suggestions! Please:

1. **Check existing issues** to avoid duplicates
2. **Use our feature request template**
3. **Explain the use case** and why it would be valuable
4. **Consider backward compatibility**
5. **Be open to discussion** about implementation

## 🔒 Security Issues

**Please don't report security vulnerabilities in public issues.**

Instead:
1. Email the maintainers privately
2. Use GitHub's private vulnerability reporting
3. Wait for acknowledgment before public disclosure

We take security seriously and will respond promptly.

## 📋 Code of Conduct

### Our Standards

Examples of behavior that contributes to a positive environment:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

### Unacceptable Behavior

Examples of unacceptable behavior include:

- The use of sexualized language or imagery
- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

## 🎯 Areas for Contribution

We especially welcome contributions in these areas:

### High Priority
- 🐛 **Bug fixes** - Resolve existing issues
- 📚 **Documentation** - Improve clarity and completeness
- 🧪 **Testing** - Expand test coverage
- 🔒 **Security** - Enhance security practices

### Medium Priority
- ✨ **New configurations** - Add useful package combinations
- 🎨 **UI/UX** - Improve user experience
- ⚡ **Performance** - Optimize build times
- 🌍 **Localization** - Support for different regions

### Nice to Have
- 🔧 **Tooling** - Developer experience improvements
- 📦 **Packaging** - Better distribution methods
- 🔗 **Integrations** - Third-party tool support

## 🚀 Getting Started

1. **Set up your development environment**:
   ```bash
   # Install Nix with flakes support
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

   # Clone your fork
   git clone https://github.com/YOUR-USERNAME/nix-darwin-kickstarter.git
   cd nix-darwin-kickstarter
   ```

2. **Understand the project structure**:
   ```
   ├── minimal/          # Beginner-friendly configuration
   ├── rich-demo/        # Advanced configuration with home-manager
   ├── scripts/          # Deployment and setup scripts
   ├── .github/          # CI/CD workflows and templates
   └── docs/             # Additional documentation
   ```

3. **Make your first contribution**:
   - Look for issues labeled `good first issue`
   - Check the project board for current priorities
   - Ask questions in discussions if unsure

## 🤝 Community

- 💬 **Discussions**: Ask questions and share ideas
- 🐛 **Issues**: Report bugs and request features
- 📧 **Email**: Contact maintainers for sensitive issues
- 🐦 **Social**: Follow project updates

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

All contributors will be recognized in our README and release notes. We appreciate every contribution, no matter how small!

---

**Thank you for contributing to Nix Darwin Kickstarter! 🎉**