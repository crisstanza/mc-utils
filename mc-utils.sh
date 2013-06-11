#!/bin/sh

clear;

FONT_DEFAULT="\033[0m"
FONT_RED="\033[31m"
FONT_GREEN="\033[32m"
FONT_YELLOW="\033[33m"
FONT_BLUE="\033[34m"

AUTO_CLEAN_UP=1
CLEAR_SCREEN=1

SYSTEM_APPLICATIONS_FOLDER="/Applications"

CURRENT_FOLDER=`pwd`

THINGS_FOLDER="$CURRENT_FOLDER/things"
TMP_FOLDER="$THINGS_FOLDER/tmp"
BKP_FOLDER="$THINGS_FOLDER/bkp"

MAIN_FILE_FOLDER_ROOT="/Users/crisstanza/Library/Application Support/minecraft"
MAIN_FILE_FOLDER="$MAIN_FILE_FOLDER_ROOT/bin"
MAIN_FILE="minecraft.jar"

MINECRAFT_INSTALLER_FOLDER="$THINGS_FOLDER/Minecraft"
MINECRAFT_INSTALLER_FILE="Minecraft-1.5.2.app"

MINECRAFT_FORGE_INSTALLER_FOLDER="$THINGS_FOLDER/Minecraft-Forge"
MINECRAFT_FORGE_INSTALLER_FILE_NAME="minecraftforge-universal-1.5.2-7.8.0.688"
MINECRAFT_FORGE_INSTALLER_FILE="$MINECRAFT_FORGE_INSTALLER_FILE_NAME.zip"

PIXELMON_INSTALLER_FOLDER="$THINGS_FOLDER/Pixelmon"
PIXELMON_INSTALLER_FILE_NAME="Pixelmon-2.2.1-Install"
PIXELMON_INSTALLER_FILE="$PIXELMON_INSTALLER_FILE_NAME.zip"

SKINS_FOLDER="$THINGS_FOLDER/Skins"
SKIN_CHAR_FOLDER="$SKINS_FOLDER/Char/mario"
SKIN_CHAR_FOLDER_ORIG="$SKINS_FOLDER/Char/orig"
SKIN_CHAR_FILE="mob/char.png"

function doSetup() {
	if [ -d "$THINGS_FOLDER" ] ; then
		if [ -d "$TMP_FOLDER" ] ; then
			rm -R "$TMP_FOLDER"
		fi
		mkdir "$TMP_FOLDER"
		#
		if [ ! -d "$BKP_FOLDER" ] ; then
			mkdir "$BKP_FOLDER"
		fi
		#
		#if [ ! -d "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
		#	doQuit "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
		#fi
		#
		if [ ! -d "$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE" ] ; then
			doQuit "${FONT_RED}Arquivo '$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE' não encontrado!${FONT_DEFAULT}"
		fi
		#
		#if [ ! -d "$MINECRAFT_FORGE_INSTALLER_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE" ] ; then
		#	doQuit "${FONT_RED}Arquivo '$MINECRAFT_FORGE_INSTALLER_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE' não encontrado!${FONT_DEFAULT}"
		#fi
		#
		#if [ ! -d "$SKINS_FOLDER/$SKIN_CHAR_FILE" ] ; then
		#	doQuit "${FONT_RED}Arquivo '$SKINS_FOLDER/$SKIN_CHAR_FILE' não encontrado!${FONT_DEFAULT}"
		#fi
	else
		doQuit "${FONT_RED}Diretório '$THINGS_FOLDER' não encontrado!${FONT_DEFAULT}"
	fi
}

function doQuit() {
	local msg="$1";
	if [ "$msg" != "" ] ; then
		echo
		echo $msg;
	fi
	echo
	exit 0;
}

function doBackup() {
	cp "$MAIN_FILE_FOLDER/$MAIN_FILE" "$BKP_FOLDER"
	showMainMenu "${FONT_BLUE}Back-up efetuado com sucesso!${FONT_DEFAULT}"
}

function doBackupRestore() {
	cp "$BKP_FOLDER/$MAIN_FILE" "$MAIN_FILE_FOLDER"
	showMainMenu "${FONT_BLUE}Back-up restaurado com sucesso!${FONT_DEFAULT}"
}

function doInstallMinecraftForge() {
	unzip -x "$MINECRAFT_FORGE_INSTALLER_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE" -d "$TMP_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE_NAME.unzip"
	cd "$TMP_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE_NAME.unzip"
	zip -r "$MAIN_FILE_FOLDER/$MAIN_FILE" *
	zip -d "$MAIN_FILE_FOLDER/$MAIN_FILE" META-INF\*
	if [ "$AUTO_CLEAN_UP" == 1 ] ; then
		rm -R "$TMP_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE_NAME.unzip"
	fi
	showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
}

function doInstallPixelmon() {
	unzip -x "$PIXELMON_INSTALLER_FOLDER/$PIXELMON_INSTALLER_FILE" -d "$TMP_FOLDER/$PIXELMON_INSTALLER_FILE_NAME.unzip"
	cd "$TMP_FOLDER/$PIXELMON_INSTALLER_FILE_NAME.unzip"
	cp -Rf database "$MAIN_FILE_FOLDER_ROOT"
	cp -Rf mods "$MAIN_FILE_FOLDER_ROOT"
	if [ "$AUTO_CLEAN_UP" == 1 ] ; then
		rm -R "$TMP_FOLDER/$PIXELMON_INSTALLER_FILE_NAME.unzip"
	fi
	showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
}

function doInstallSkinChar() {
	cd "$SKIN_CHAR_FOLDER"
	zip -r "$MAIN_FILE_FOLDER/$MAIN_FILE" "$SKIN_CHAR_FILE"
	showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
}

function doUninstallSkinChar() {
	cd "$SKIN_CHAR_FOLDER_ORIG"
	zip -r "$MAIN_FILE_FOLDER/$MAIN_FILE" "$SKIN_CHAR_FILE"
	showMainMenu "${FONT_BLUE}Desinstalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
}

function doInstall() {
	cp -R "$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE" "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE"
	showMainMenu "${FONT_BLUE}Instalação concluída com sucesso!${FONT_DEFAULT}"
}

function doUninstall() {
	rm -R "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE"
	showMainMenu "${FONT_RED}Desinstalação concluída com sucesso!${FONT_DEFAULT}"
}

function doCleanUpPersonalFolder() {
	rm -R "$MAIN_FILE_FOLDER_ROOT"
	showMainMenu "${FONT_BLUE}Pasta '$MAIN_FILE_FOLDER_ROOT' removida com sucesso!${FONT_DEFAULT}"
}

function doStartGame() {
	open "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE"
	showMainMenu "${FONT_BLUE}Jogo iniciado! Verifique a outra janela. ${FONT_DEFAULT}"
}

function doQuitGame() {
	local pid=`ps -A | grep -m1 $SYSTEM_APPLICATIONS_FOLDER/[$MINECRAFT_INSTALLER_FILE] | awk '{print $1}'`
	if [ "$pid" == "" ] ; then
		showMainMenu "${FONT_RED}O jogo não está rodando!${FONT_DEFAULT}"
	else
		kill "$pid"
		showMainMenu "${FONT_BLUE}Jogo encerrado com sucesso!${FONT_DEFAULT}"
	fi
}

function showMainMenu() {
	if [ "$CLEAR_SCREEN" == 1 ] ; then
		clear;
	fi
	local msg="$1";
	if [ "$msg" != "" ] ; then
		echo
		echo $msg;
	fi
	#
	echo
	echo "${FONT_GREEN}O que você deseja?${FONT_DEFAULT}"
	echo
	echo "   ${FONT_GREEN}1)${FONT_DEFAULT} Instalar Minecraft            ${FONT_GREEN}2)${FONT_DEFAULT} Desinstalar Minecraft      ${FONT_GREEN}3)${FONT_DEFAULT} Apagar pasta pessoal";
	echo "   ${FONT_GREEN}4)${FONT_DEFAULT} Fazer back-up                 ${FONT_GREEN}5)${FONT_DEFAULT} Restaurar back-up";
	echo "   ${FONT_GREEN}6)${FONT_DEFAULT} Instalar Skin Personagem      ${FONT_GREEN}7)${FONT_DEFAULT} Desinstalar Skin Personagem";
	echo "   ${FONT_GREEN}8)${FONT_DEFAULT} Instalar Minecraft Forge      ${FONT_GREEN}9)${FONT_DEFAULT} Instalar Pixelmon";
	echo
	echo "   ${FONT_GREEN}R)${FONT_DEFAULT} Rodar o jogo                  ${FONT_GREEN}E)${FONT_DEFAULT} Encerrar o jogo";
	echo
	echo "   ${FONT_YELLOW}S)${FONT_DEFAULT} Sair";
	echo
	echo ":\c";
	#
	read option
	#
	if [ "$option" == "1" ] ; then
		doInstall;
	elif [ "$option" == "2" ] ; then
		doUninstall;
	elif [ "$option" == "3" ] ; then
		doCleanUpPersonalFolder;
	elif [ "$option" == "4" ] ; then
		doBackup;
	elif [ "$option" == "5" ] ; then
		doBackupRestore;
	elif [ "$option" == "6" ] ; then
		doInstallSkinChar;
	elif [ "$option" == "7" ] ; then
		doUninstallSkinChar;
	elif [ "$option" == "8" ] ; then
		doInstallMinecraftForge;
	elif [ "$option" == "9" ] ; then
		doInstallPixelmon;
	elif [ "$option" == "R" -o "$option" == "r" ] ; then
		doStartGame;
	elif [ "$option" == "E" -o "$option" == "e" ] ; then
		doQuitGame;
	elif [ "$option" == "S" -o "$option" == "s" ] ; then
		doQuit;
	else
		showMainMenu "${FONT_RED}Digite uma das opções válidas!${FONT_DEFAULT}"
	fi
	return;
}

doSetup;
showMainMenu;

exit 0;
