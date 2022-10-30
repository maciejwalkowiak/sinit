#!/bin/sh

export GUM_INPUT_CURSOR_FOREGROUND="#FF0"
export GUM_INPUT_PROMPT_FOREGROUND="#0FF"
export GUM_INPUT_PROMPT="> "
export GUM_INPUT_WIDTH=80

HIGHLIGHT="#5DA831"

clear

gum style \
	--foreground 212 --border-foreground $HIGHLIGHT --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'sinit - shiny Spring Boot project initializer' 'by @maciejwalkowiak'

echo "How do you want to $(gum style --foreground $HIGHLIGHT "name") your project? (no spaces please)"

PROJECT_NAME=$(gum input --placeholder "project name")

echo "$(gum style --foreground $HIGHLIGHT "Project Name"): $PROJECT_NAME"

# fetch JSON with start.spring.io metadata
METADATA=$(curl -s "https://start.spring.io/metadata/client")

# choose project type (Maven/Gradle)
AVAILABLE_PROJECT_TYPES=$(echo $METADATA | jq -r '.type.values[].id | select ( . | contains("project") )' | sed 's/-project//g')
echo "What $(gum style --foreground $HIGHLIGHT "build tool") do you want to use?"
TYPE="$(gum choose $AVAILABLE_PROJECT_TYPES)-project"
echo "$(gum style --foreground $HIGHLIGHT "Build tool"): $TYPE"

# choose spring boot version
AVAILABLE_BOOT_VERSIONS=$(echo $METADATA | jq -r '.bootVersion.values[].id')
VERSION=$(gum choose $AVAILABLE_BOOT_VERSIONS)
echo "Choose Spring Boot $(gum style --foreground $HIGHLIGHT "version")"
echo "$(gum style --foreground $HIGHLIGHT "Spring Boot version"): $VERSION"

# generate project
gum spin --title "Generating project" -- curl https://start.spring.io/starter.zip -d dependencies=web -d bootVersion=$VERSION -d type=$TYPE -d name=$PROJECT_NAME -o $PROJECT_NAME.zip && unzip -q $PROJECT_NAME.zip -d $PROJECT_NAME && rm $PROJECT_NAME.zip
echo "Congrats! Spring Boot project is generated! 🚀"

# push to github?
gum confirm "Push to Github?"

if [ $? -eq 0 ]; then
  # create a git repository and push to github
  cd $PROJECT_NAME
  git init
  git add .
  git commit -m "initial commit"
  gh repo create $PROJECT_NAME --private --push --source .

  echo "Open project in an $(gum style --foreground $HIGHLIGHT "IDE")?"
  IDE=$(gum choose "Intellij IDEA" "Gitpod" "Nope")
  if [ "$IDE" = "Intellij IDEA" ]
  then
    idea .
  elif [ "$IDE" = "Gitpod" ]
  then
    open "https://gitpod.io/#$(git remote get-url --push origin)"
  fi
else
  gum confirm "Open in Intellij IDEA?"
  if [ $? -eq 0 ]; then
    idea $PROJECT_NAME
    exit
  fi
fi

echo "$(gum style --foreground $HIGHLIGHT "Happy coding! 😊")"
