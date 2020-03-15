# Deplojer

A simple command line tool to deploy your beloved dotfiles under various platforms.

## Usage

First you need to create a new platform:

> deplojer add linux

This command would create a **linux** platform. (It is possilble to chain multiple platforms seperated by a space)

By entering this command *deplojer* will create the following file structure:

```
platforms
├── config.yaml
├── linux
│   ├── files
│   └── gap_filler
└── master
    └── files
```

### config.yaml

This file is used to maintain some configuration for deployment. See section **CONFIGURATION** for a more detailed description.

### master

This directory is used for the general dotfiles. 
Files placed in here will be deployed on each system equally.

### linux

In here you place dotfiles you want only to be deployed on the platform linux.

> Attention: The platform name is just a namespace given by the user. It'll **not** determine automatically the platform by the given name. For better understanding read section *RUN*

#### gap_filler

In here you'll place *"Mixin"* files. These files will be mixed into the files form **master** (not from the platform specific directory).

## RUN

You can execute the actual script by entering following command:

```
pc> deplojer run linux
```

This will execute deployment for the platform *linux*.

### What happens during execution?

1. Files from the platforms folder will be deployed.
2. Files from master will be mixed with *gap_filler* files
3. Mixed files from master will be deployed

## CONFIGURATION
