# Beanstalk to GitHub Repository Migration

This guide provides two methods for migrating Git repositories from Beanstalk to GitHub while preserving the complete repository history, including branches and tags.

## Method 1: Manual Migration Process

### Prerequisites
- Git installed on your machine
- SSH key configured for GitHub
- Access to both Beanstalk and GitHub repositories

### Step-by-Step Instructions

1. **Clone the Beanstalk repository using --mirror**
   ```bash
   git clone --mirror git@buddyboss.git.beanstalkapp.com:/buddyboss/buddyboss-welcome-experience.git
   ```

2. **Change into the cloned repo directory**
   ```bash
   cd buddyboss-welcome-experience.git
   ```

3. **Create a new repository on GitHub**
   - Go to: https://github.com/new
   - Name the repository: buddyboss-welcome-experience
   - Do not initialize it with a README or license file (keep it empty)

4. **Update the origin URL to point to GitHub**
   ```bash
   git remote set-url origin git@github.com:surajkrsingh/buddyboss-welcome-experience.git
   ```

5. **Push the mirrored repository to GitHub**
   ```bash
   git push --mirror
   ```

6. **Clean up local clone**
   ```bash
   cd ..
   rm -rf buddyboss-welcome-experience.git
   ```

### Important Notes
- The `--mirror` option ensures a full mirror of all references
- Double-check GitHub permissions and SSH key setup if authentication fails
- This process can be repeated for other repositories by changing the repository name and URLs accordingly

### Demo
- [Watch the migration process](https://go.screenpal.com/watch/cThjIAnQgYm)

## Method 2: Automated Migration Process

### Prerequisites
- Git installed on your machine
- GitHub CLI (gh) installed
- SSH key configured:
  - Already set up on your machine
  - Public key added to your GitHub account: https://github.com/settings/keys

### Step-by-Step Instructions

1. **Create beanstalk_repos.txt**
   - List all your Beanstalk repo URLs using SSH format
   - Example format available at: [beanstalk_repos.txt](https://github.com/surajkrsingh/beanstalk-to-github-migration/blob/main/beanstalk_repos.txt)

2. **Set up the Migration Script**
   - Download the migration script: [migrate_beanstalk_to_github.sh](https://github.com/surajkrsingh/beanstalk-to-github-migration/blob/main/migrate_beanstalk_to_github.sh)
   - Make it executable:
     ```bash
     chmod +x migrate_beanstalk_to_github.sh
     ```
   - Load your SSH key:
     ```bash
     ssh-add ~/.ssh/id_ed25519
     ```
   - Run the script:
     ```bash
     ./migrate_beanstalk_to_github.sh
     ```

### Demo Videos
- [Script running log](https://go.screenpal.com/watch/cThjIvnQgqV)
- [Repos created](https://go.screenpal.com/watch/cThjIwnQgq2)
- [Get repo with history](https://go.screenpal.com/watch/cThjIwnQgqF)
