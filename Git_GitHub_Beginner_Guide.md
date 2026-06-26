# Git & GitHub — Complete Beginner's Guide

This guide assumes you have **never installed or used Git/GitHub before**. Follow it step by step — don't skip steps.

## Quick Concepts (read this first)

- **Git** = a tool installed on your computer that tracks changes to your files (version control).
- **GitHub** = a website that hosts your Git project online, so others (recruiters, interviewers) can see it.
- **Repository ("repo")** = a project folder that Git is tracking. It can live on your computer (local) and on GitHub (remote).
- You write/edit files locally → "commit" them (save a checkpoint) → "push" them to GitHub (upload).

---

## Step 1: Create a GitHub Account

1. Go to https://github.com
2. Click **Sign up**, enter email, password, choose a username (use something professional, e.g. `firstname-lastname`, since recruiters may see it).
3. Verify your email.

---

## Step 2: Install Git on Your Computer

### Windows
1. Go to https://git-scm.com/downloads
2. Download the Windows installer and run it.
3. During installation, keep clicking "Next" with default options (defaults are fine for beginners).
4. After installation, open **Git Bash** (search for it in the Start menu) — this is the terminal you'll use to run Git commands.

### Mac
1. Open **Terminal** app.
2. Type: `git --version`
3. If Git isn't installed, macOS will prompt you to install Developer Tools — click **Install**.

### Verify Installation
In Git Bash (Windows) or Terminal (Mac), type:
```bash
git --version
```
You should see something like `git version 2.4x.x`. If yes, Git is installed correctly.

---

## Step 3: Configure Git (one-time setup)

In Git Bash / Terminal, run these two commands (replace with your own name and the email you used for GitHub):

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

This tells Git who is making the commits — it'll show up next to your changes on GitHub.

---

## Step 4: Create a New Repository on GitHub

1. Log into GitHub.
2. Click the **+** icon (top right) → **New repository**.
3. Repository name: `insurance-sql-portfolio` (or any name you like).
4. Description: "SQL & PL/SQL portfolio project — Agriculture & Motor Insurance domain".
5. Choose **Public** (so recruiters can view it without logging in).
6. **Do NOT** check "Add a README file" if you already have one ready locally (you do — skip this checkbox). If you're starting totally fresh with nothing on your computer yet, you can check it.
7. Click **Create repository**.

GitHub will now show you a page with a URL like:
```
https://github.com/your-username/insurance-sql-portfolio.git
```
Keep this page open — you'll need that URL in Step 6.

---

## Step 5: Prepare Your Project Folder Locally

1. On your computer, create a folder for your project (or use the one already prepared, e.g. `insurance-sql-portfolio`) containing your README.md, scripts/, and docs/ folders.
2. Open Git Bash (Windows) or Terminal (Mac).
3. Navigate into that folder. Example:
```bash
cd Desktop/insurance-sql-portfolio
```
(Adjust the path to wherever your folder actually is.)

---

## Step 6: Initialize Git and Push Your Project to GitHub

Run these commands **one at a time**, in order, inside your project folder:

```bash
# 1. Initialize git tracking in this folder
git init

# 2. Check what files Git sees (optional, just to confirm)
git status

# 3. Stage all files (tell Git you want to save these)
git add .

# 4. Commit — save a checkpoint with a message describing what you did
git commit -m "Initial commit: insurance SQL and PLSQL portfolio"

# 5. Rename your default branch to 'main' (modern GitHub standard)
git branch -M main

# 6. Connect your local folder to the GitHub repository you created
git remote add origin https://github.com/your-username/insurance-sql-portfolio.git

# 7. Push (upload) your files to GitHub
git push -u origin main
```

> Replace `your-username` with your actual GitHub username in step 6.

If this is your first time pushing, GitHub may open a browser window asking you to log in and authorize — just follow the prompts.

After this completes, refresh your GitHub repository page in the browser — your files should now appear there.

---

## Step 7: Making Future Changes (after today)

Whenever you edit a file or add a new script later, repeat this short cycle:

```bash
git add .
git commit -m "Describe what you changed, e.g. Added claim settlement query"
git push
```

That's it — `git init` and `git remote add origin` are **one-time** steps; you don't repeat them.

---

## Common Beginner Mistakes to Avoid

- **Forgetting `git add .` before commit** → Git will say "nothing to commit" because it doesn't know which files to save yet.
- **Writing vague commit messages** like "update" — instead write what changed, e.g. "Added PLSQL trigger for premium payment validation".
- **Committing sensitive data** (passwords, real customer data, API keys) — never push real/confidential data to a public repo. This repo only uses dummy data for this reason.
- **Pushing to the wrong branch** — for a simple personal project, stick to `main` and you'll be fine.

---

## Useful Commands Cheat Sheet

| Command                          | What it does                                      |
|------------------------------------|------------------------------------------------------|
| `git status`                          | Shows what's changed / staged / not staged          |
| `git add .`                              | Stages all changed files                            |
| `git add filename.sql`                      | Stages one specific file                          |
| `git commit -m "message"`                      | Saves a checkpoint with a description           |
| `git push`                                       | Uploads commits to GitHub                       |
| `git pull`                                         | Downloads latest changes from GitHub          |
| `git log`                                            | Shows commit history                        |
| `git clone <url>`                                      | Downloads a copy of a GitHub repo to your computer |

---

## What to Do Next

1. Follow Steps 1–6 above to get this exact project live on your GitHub profile.
2. Add the GitHub repository link to your resume and LinkedIn profile.
3. Over time, keep adding new SQL scripts you write/practice — this becomes a living portfolio, not a one-time upload.
