#!/bin/sh

FONT_DEFAULT="\033[0m"
FONT_RED="\033[31m"
FONT_GREEN="\033[32m"
FONT_YELLOW="\033[33m"
FONT_BLUE="\033[34m"

SYSTEM_APPLICATIONS_FOLDER="/Applications"

CURRENT_FOLDER=`pwd`

THINGS_FOLDER="$CURRENT_FOLDER/things"
TMP_FOLDER="$THINGS_FOLDER/tmp"
BKP_FOLDER="$THINGS_FOLDER/bkp"

MAIN_FILE_FOLDER="/Users/$USER/Library/MyTest/bin"
MAIN_FILE="test-file.zip"

MINECRAFT_INSTALLER_FOLDER="$THINGS_FOLDER/Minecraft"
MINECRAFT_INSTALLER_FILE="Minecraft.app"

MINECRAFT_FORGE_INSTALLER_FOLDER="$THINGS_FOLDER/Minecraft-Forge"
MINECRAFT_FORGE_INSTALLER_FILE_NAME="test"
MINECRAFT_FORGE_INSTALLER_FILE="$MINECRAFT_FORGE_INSTALLER_FILE_NAME.zip"

SKINS_FOLDER="$THINGS_FOLDER/Skins"
SKIN_CHAR_FILE="char.png"

function doSetup() {
	clear;
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
		if [ ! -d "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
			doQuit "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}";
		fi
		#
		if [ ! -d "$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE" ] ; then
			doQuit "${FONT_RED}Arquivo '$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE' não encontrado!${FONT_DEFAULT}";
		fi
		#
		if [ ! -d "$MINECRAFT_FORGE_INSTALLER_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE" ] ; then
			doQuit "${FONT_RED}Arquivo '$MINECRAFT_FORGE_INSTALLER_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE' não encontrado!${FONT_DEFAULT}";
		fi
		#
		if [ ! -d "$SKINS_FOLDER/$SKIN_CHAR_FILE" ] ; then
			doQuit "${FONT_RED}Arquivo '$SKINS_FOLDER/$SKIN_CHAR_FILE' não encontrado!${FONT_DEFAULT}";
		fi
	else
		doQuit "${FONT_RED}Diretório '$THINGS_FOLDER' não encontrado!${FONT_DEFAULT}";
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
	showMainMenu "${FONT_BLUE}Back-up efetuado com sucesso!${FONT_DEFAULT}";
}

function doBackupRestore() {
	cp "$BKP_FOLDER/$MAIN_FILE" "$MAIN_FILE_FOLDER"
	showMainMenu "${FONT_BLUE}Back-up restaurado com sucesso!${FONT_DEFAULT}";
}

function doInstallMinecraftForge() {
	unzip -x "$MINECRAFT_FORGE_INSTALLER_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE" -d "$TMP_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE_NAME.unzip"
	cd "$TMP_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE_NAME.unzip"
	zip -r "$MAIN_FILE_FOLDER/$MAIN_FILE" *
	zip -d "$MAIN_FILE_FOLDER/$MAIN_FILE" META-INF\*
	rm -R "$TMP_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE_NAME.unzip"
	showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}";
}

function doInstallSkinChar() {
	cd "$SKINS_FOLDER"
	zip "$MAIN_FILE_FOLDER/$MAIN_FILE" "$SKIN_CHAR_FILE"
	showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}";
}

function doInstall() {
	cp "$MINECRAFT_FORGE_INSTALLER_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE" "$SYSTEM_APPLICATIONS_FOLDER"
	showMainMenu "${FONT_BLUE}Instalação concluída com sucesso!${FONT_DEFAULT}";
}

function doUninstall() {
	rm -R "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_FORGE_INSTALLER_FILE"
	showMainMenu "${FONT_RED}Desinstalação concluída com sucesso!${FONT_DEFAULT}";
}

function showMainMenu() {
	clear;
	local msg="$1";
	if [ "$msg" != "" ] ; then
		echo
		echo $msg;
	fi
	#
	echo
	echo "${FONT_GREEN}O que você deseja?${FONT_DEFAULT}";
	echo
	echo "   ${FONT_GREEN}1)${FONT_DEFAULT} Instalar Minecraft            ${FONT_GREEN}2)${FONT_DEFAULT} Desinstalar Minecraft";
	echo "   ${FONT_GREEN}3)${FONT_DEFAULT} Fazer back-up                 ${FONT_GREEN}4)${FONT_DEFAULT} Restaurar back-up";
	echo "   ${FONT_GREEN}5)${FONT_DEFAULT} Instalar Skin Personagem";
	echo "   ${FONT_GREEN}6)${FONT_DEFAULT} Instalar Minecraft Forge";
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
		doBackup;
	elif [ "$option" == "4" ] ; then
		doBackupRestore;
	elif [ "$option" == "5" ] ; then
		doInstallSkinChar;
	elif [ "$option" == "6" ] ; then
		doInstallMinecraftForge;
	elif [ "$option" == "S" -o "$option" == "s" ] ; then
		doQuit;
	else
		showMainMenu "${FONT_RED}Digite uma das opções válidas!${FONT_DEFAULT}";
	fi
	return;
}

doSetup;
showMainMenu;

exit 0;
