@echo on

cmd /c "yarn install"
if errorlevel 1 exit 1

@rem port yarn.lock to pnpm-lock.yaml
cmd /c "pnpm import"
if errorlevel 1 exit 1

@rem install all (prod) dependencies, this needs to be done for pnpm to properly list all dependencies later on
cmd /c "pnpm install"
if errorlevel 1 exit 1

cmd /c "pnpm pack"
if errorlevel 1 exit 1

cmd /c "npm install -g %PKG_NAME%-%PKG_VERSION%.tgz"
if errorlevel 1 exit 1

@rem list all dependencies and then call pnpm-licenses to generate the ThirdPartyLicenses.txt file
cmd /c "pnpm licenses list --prod --json | pnpm-licenses generate-disclaimer --prod --json-input --output-file=ThirdPartyLicenses.txt"
if errorlevel 1 exit 1

@rem log directory structure in order to easily verify if porting yarn.lock, installing packages and generating licenses worked
dir
