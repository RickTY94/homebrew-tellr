# Homebrew formula for tellr - AI slide generator for Databricks
# 
# This formula installs tellr from the public GitHub repository.
# Users configure their Databricks workspace URL through the UI on first run.
#
# Installation:
#   brew tap RickTY94/tellr
#   brew install tellr
#
# Usage:
#   tellr        # Start the app
#   tellr stop   # Stop the app
#   tellr status # Check status

class Tellr < Formula
  desc "AI-powered slide generator for Databricks"
  homepage "https://github.com/robertwhiffin/ai-slide-generator"
  url "https://github.com/robertwhiffin/ai-slide-generator/archive/9aac55f5f42721fe66f450140caf20fd2c5f404e.tar.gz"
  version "2026.08.18.9aac55f"
  sha256 "390f2c0763f036b39d805d2f70414fac8fd1aca976eca9c60e5fe12a98a11739"
  license "Apache-2.0"

  # Dependencies
  depends_on "python@3.11"
  depends_on "postgresql@14"
  depends_on "node@20"

  def install
    # Install all app files to libexec
    libexec.install Dir["*"]
    libexec.install Dir[".*"].select { |f| File.file?(f) }

    # Create Python virtual environment
    cd libexec do
      system "python3.11", "-m", "venv", ".venv"
      system ".venv/bin/pip", "install", "--upgrade", "pip"
      system ".venv/bin/pip", "install", "-r", "requirements.txt"
      system ".venv/bin/pip", "install", "click", "pyyaml"  # CLI dependencies
    end

    # Build frontend
    cd libexec/"frontend" do
      system "npm", "install"
      system "npm", "run", "build"
    end

    # Create the tellr CLI wrapper script
    (bin/"tellr").write <<~EOS
      #!/bin/bash
      export TELLR_HOME="#{libexec}"
      export PATH="#{libexec}/.venv/bin:$PATH"
      exec "#{libexec}/.venv/bin/python" "#{libexec}/scripts/tellr_cli.py" "$@"
    EOS
  end

  def post_install
    # Create logs directory
    (var/"log/tellr").mkpath
    
    # Ensure PostgreSQL is started
    system "brew", "services", "start", "postgresql@14"
    
    # Create database if it doesn't exist
    sleep 2  # Give PostgreSQL time to start
    system "createdb", "ai_slide_generator", "-h", "localhost" rescue nil
    
    ohai "tellr installed successfully!"
    ohai ""
    ohai "To start tellr, run:"
    ohai "  tellr"
    ohai ""
    ohai "On first run, you'll be prompted to enter your Databricks workspace URL."
  end

  def caveats
    <<~EOS
      tellr has been installed!

      To start tellr:
        tellr

      On first run, enter your Databricks workspace URL in the browser.
      You'll then sign in with your Databricks credentials.

      Other commands:
        tellr stop     # Stop the app
        tellr status   # Check if running
        tellr reset    # Reset configuration

      To update tellr:
        brew upgrade tellr
    EOS
  end

  service do
    run [opt_bin/"tellr", "start", "--no-browser"]
    keep_alive false
    log_path var/"log/tellr/tellr.log"
    error_log_path var/"log/tellr/tellr-error.log"
    working_dir opt_libexec
  end

  test do
    # Basic test - check CLI works
    system "#{bin}/tellr", "--help"
  end
end
