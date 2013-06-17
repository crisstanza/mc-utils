#!/bin/sh

clear;

FONT_DEFAULT="\033[0m"
FONT_RED="\033[31m"
FONT_GREEN="\033[32m"
FONT_YELLOW="\033[33m"
FONT_BLUE="\033[34m"

if [ "$1" == "debug-mode" ]; then
	CLEAR_SCREEN=0
	AUTO_CLEAN_UP=0
	USER_MODE=0
elif [ "$1" == "user-mode" ]; then
	CLEAR_SCREEN=1
	AUTO_CLEAN_UP=1
	USER_MODE=1
fi

SYSTEM_APPLICATIONS_FOLDER="/Applications"

CURRENT_FOLDER=`pwd`

THINGS_FOLDER="$CURRENT_FOLDER/things"
TMP_FOLDER="$THINGS_FOLDER/tmp"
BKP_FOLDER="$THINGS_FOLDER/bkp"

MINECRAFT_INSTALLER_FOLDER="$THINGS_FOLDER/Minecraft"
MINECRAFT_INSTALLER_FILE="Minecraft-1.5.2.app"
MINECRAFT_INSTALLER_FILE_TRICK="Minecraft-1.5.2.ap[p]"

MAIN_FILE_FOLDER_ROOT="/Users/$USER/Library/Application Support/minecraft"
MAIN_FILE_FOLDER="$MAIN_FILE_FOLDER_ROOT/bin"
MAIN_FILE_ORIG_FOLDER="$MINECRAFT_INSTALLER_FOLDER"
MAIN_FILE="minecraft.jar"

MINECRAFT_FORGE_INSTALLER_FOLDER="$THINGS_FOLDER/Minecraft-Forge"
MINECRAFT_FORGE_INSTALLER_FILE_NAME="minecraftforge-universal-1.5.2-7.8.0.688"
MINECRAFT_FORGE_INSTALLER_FILE="$MINECRAFT_FORGE_INSTALLER_FILE_NAME.zip"

MODLOADER_INSTALLER_FOLDER="$THINGS_FOLDER/ModLoader"
MODLOADER_INSTALLER_FILE_NAME="ModLoader-1.5.2"
MODLOADER_INSTALLER_FILE="$MODLOADER_INSTALLER_FILE_NAME.zip"

PIXELMON_INSTALLER_FOLDER="$THINGS_FOLDER/Pixelmon"
PIXELMON_INSTALLER_FILE_NAME="Pixelmon-2.2.1-Install"
PIXELMON_INSTALLER_FILE="$PIXELMON_INSTALLER_FILE_NAME.zip"

REIS_MINIMAP_INSTALLER_FOLDER="$THINGS_FOLDER/Reis-Minimap"
REIS_MINIMAP_INSTALLER_FILE_NAME="Reis-Minimap-Mod-1.5.2"
REIS_MINIMAP_INSTALLER_FILE="$REIS_MINIMAP_INSTALLER_FILE_NAME.zip"

SKINS_FOLDER="$THINGS_FOLDER/Skins"
SKIN_CHAR_FILE="mob/char.png"

SKIN_CHAR_ORIG_FOLDER="$SKINS_FOLDER/Char/orig"
SKIN_CHAR_MARIO_FOLDER="$SKINS_FOLDER/Char/mario"
SKIN_CHAR_RAPHAEL_FOLDER="$SKINS_FOLDER/Char/raphael"
SKIN_CHAR_ZOMBIE_FOLDER="$SKINS_FOLDER/Char/zombie"
SKIN_CHAR_HEMAN_FOLDER="$SKINS_FOLDER/Char/he-man"

function doSetup() {
	if [ -d "$THINGS_FOLDER" ] ; then
		if [ -d "$TMP_FOLDER" ] ; then
			rm -R "$TMP_FOLDER"
		fi
		mkdir "$TMP_FOLDER"
		if [ ! -d "$BKP_FOLDER" ] ; then
			mkdir "$BKP_FOLDER"
		fi
	else
		doQuit "${FONT_RED}Diretório '$THINGS_FOLDER' não encontrado!${FONT_DEFAULT}"
	fi
}

function doQuit() {
	clear
	local msg="$1";
	if [ "$msg" != "" ] ; then
		echo
		echo $msg;
	fi
	echo
	if [ "$USER_MODE" == 1 ] ; then
		osascript -e 'tell application "Terminal" to quit'
	fi
	exit 0;
}

function doBackup() {
	if [ -f "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
		cp "$MAIN_FILE_FOLDER/$MAIN_FILE" "$BKP_FOLDER"
		showMainMenu "${FONT_BLUE}Back-up efetuado com sucesso!${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doBackupRestore() {
	if [ -f "$BKP_FOLDER/$MAIN_FILE" ] ; then
		cp "$BKP_FOLDER/$MAIN_FILE" "$MAIN_FILE_FOLDER"
		showMainMenu "${FONT_BLUE}Back-up restaurado com sucesso!${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Arquivo '$BKP_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doUninstallAllMods() {
	if [ -f "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
		if [ -f "$MAIN_FILE_ORIG_FOLDER/$MAIN_FILE" ] ; then
			cp "$MAIN_FILE_ORIG_FOLDER/$MAIN_FILE" "$MAIN_FILE_FOLDER"
			if [ -d "$MAIN_FILE_FOLDER_ROOT/database" ] ; then
				rm -R "$MAIN_FILE_FOLDER_ROOT/database"
			fi
			if [ -d "$MAIN_FILE_FOLDER_ROOT/mods" ] ; then
				rm -R "$MAIN_FILE_FOLDER_ROOT/mods"
			fi
			showMainMenu "${FONT_BLUE}Modificações desinstaladas com sucesso!${FONT_DEFAULT}"
		else
			showMainMenu "${FONT_RED}Arquivo '$MAIN_FILE_ORIG_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
		fi
	else
		showMainMenu "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doInstallZipIntoJar() {
	local folder="$1"
	local fileName="$2"
	local file="$3"
	if [ -f "$folder/$file" ] ; then
		if [ -f "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
			unzip -x "$folder/$file" -d "$TMP_FOLDER/$fileName.unzip"
			cd "$TMP_FOLDER/$fileName.unzip"
			zip -r "$MAIN_FILE_FOLDER/$MAIN_FILE" *
			zip -d "$MAIN_FILE_FOLDER/$MAIN_FILE" META-INF\*
			if [ "$AUTO_CLEAN_UP" == 1 ] ; then
				rm -R "$TMP_FOLDER/$fileName.unzip"
			fi
			showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
		else
			showMainMenu "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
		fi
	else
		showMainMenu "${FONT_RED}Arquivo '$folder/$file' não encontrado!${FONT_DEFAULT}"
	fi
}

function doInstallMinecraftForge() {
	doInstallZipIntoJar $MINECRAFT_FORGE_INSTALLER_FOLDER $MINECRAFT_FORGE_INSTALLER_FILE_NAME $MINECRAFT_FORGE_INSTALLER_FILE
}

function doInstallModLoader() {
	doInstallZipIntoJar $MODLOADER_INSTALLER_FOLDER $MODLOADER_INSTALLER_FILE_NAME $MODLOADER_INSTALLER_FILE
}

function doInstallPixelmon() {
	if [ -f "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
		if [ -f "$PIXELMON_INSTALLER_FOLDER/$PIXELMON_INSTALLER_FILE" ] ; then
			if [ -d "$MAIN_FILE_FOLDER_ROOT" ] ; then
				unzip -x "$PIXELMON_INSTALLER_FOLDER/$PIXELMON_INSTALLER_FILE" -d "$TMP_FOLDER/$PIXELMON_INSTALLER_FILE_NAME.unzip"
				cd "$TMP_FOLDER/$PIXELMON_INSTALLER_FILE_NAME.unzip"
				cp -Rf database "$MAIN_FILE_FOLDER_ROOT"
				cp -Rf mods "$MAIN_FILE_FOLDER_ROOT"
				if [ "$AUTO_CLEAN_UP" == 1 ] ; then
					rm -R "$TMP_FOLDER/$PIXELMON_INSTALLER_FILE_NAME.unzip"
				fi
				showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
			else
				showMainMenu "${FONT_RED}Pasta '$MAIN_FILE_FOLDER_ROOT' não encontrada!${FONT_DEFAULT}"
			fi
		else
			showMainMenu "${FONT_RED}Arquivo '$PIXELMON_INSTALLER_FOLDER/$PIXELMON_INSTALLER_FILE' não encontrado!${FONT_DEFAULT}"
		fi
	else
		showMainMenu "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doInstallReisMinimap() {
	doInstallZipIntoJar $REIS_MINIMAP_INSTALLER_FOLDER $REIS_MINIMAP_INSTALLER_FILE_NAME $REIS_MINIMAP_INSTALLER_FILE
}

function doInstallSkinChar() {
	if [ -f "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
		local type="$1";
		if [ "$type" == "1" ] ; then cd "$SKIN_CHAR_MARIO_FOLDER"
		elif [ "$type" == "2" ] ; then cd "$SKIN_CHAR_RAPHAEL_FOLDER"
		elif [ "$type" == "3" ] ; then cd "$SKIN_CHAR_ZOMBIE_FOLDER"
		elif [ "$type" == "4" ] ; then cd "$SKIN_CHAR_HEMAN_FOLDER"
		else
			showMainMenu "${FONT_RED}Opção inválida.${FONT_DEFAULT}"
			return
		fi
		zip -r "$MAIN_FILE_FOLDER/$MAIN_FILE" "$SKIN_CHAR_FILE"
		showMainMenu "${FONT_BLUE}Instalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doUninstallSkinChar() {
	if [ -f "$MAIN_FILE_FOLDER/$MAIN_FILE" ] ; then
		cd "$SKIN_CHAR_ORIG_FOLDER"
		zip -r "$MAIN_FILE_FOLDER/$MAIN_FILE" "$SKIN_CHAR_FILE"
		showMainMenu "${FONT_BLUE}Desinstalação concluída com sucesso! Reinicíe o jogo.${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Arquivo '$MAIN_FILE_FOLDER/$MAIN_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doInstall() {
	if [ -d "$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE" ] ; then
		cp -R "$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE" "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE"
		defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
		killall -HUP Dock
		showMainMenu "${FONT_BLUE}Instalação concluída com sucesso!${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Arquivo '$MINECRAFT_INSTALLER_FOLDER/$MINECRAFT_INSTALLER_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doUninstall() {
	if [ -d "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE" ] ; then
		rm -R "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE"
		showMainMenu "${FONT_BLUE}Desinstalação concluída com sucesso!${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Arquivo '$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE' não encontrado!${FONT_DEFAULT}"
	fi
}

function doCleanUpPersonalFolder() {
	if [ -d "$MAIN_FILE_FOLDER_ROOT" ] ; then
		rm -R "$MAIN_FILE_FOLDER_ROOT"
		showMainMenu "${FONT_BLUE}Pasta '$MAIN_FILE_FOLDER_ROOT' removida com sucesso!${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Pasta '$MAIN_FILE_FOLDER_ROOT' não encontrada!${FONT_DEFAULT}"
	fi
}

function doStartGame() {
	open "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE"
	if [ "$?" == 0 ] ; then
		showMainMenu "${FONT_BLUE}Jogo iniciado! Verifique a outra janela.${FONT_DEFAULT}"
	else
		showMainMenu "${FONT_RED}Não foi possível executar '$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE'!${FONT_DEFAULT}"
	fi
}

function doQuitGame() {
	local pid=`ps -A | grep -m1 "$SYSTEM_APPLICATIONS_FOLDER/$MINECRAFT_INSTALLER_FILE_TRICK" | awk '{print $1}'`
	if [ "$pid" == "" ] ; then
		showMainMenu "${FONT_RED}O jogo não está rodando!${FONT_DEFAULT}"
	else
		kill "$pid"
		showMainMenu "${FONT_BLUE}Jogo encerrado com sucesso!${FONT_DEFAULT}"
	fi
}

function doClearScreen() {
	clear
	showMainMenu
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

	echo
	echo "${FONT_YELLOW}O que você deseja?${FONT_DEFAULT}"
	echo
	echo "   ${FONT_GREEN}1)${FONT_DEFAULT} Instalar Minecraft          ${FONT_GREEN}2)${FONT_DEFAULT} Desinstalar Minecraft   ${FONT_GREEN}3)${FONT_DEFAULT} Apagar pasta pessoal";
	echo "   ${FONT_GREEN}4)${FONT_DEFAULT} Fazer back-up               ${FONT_GREEN}5)${FONT_DEFAULT} Restaurar back-up       ${FONT_GREEN}6)${FONT_DEFAULT} Desinstalar todas as alterações";
	echo
	echo "${FONT_GREEN}Mod Loaders:${FONT_DEFAULT}"
	echo
	echo "   ${FONT_GREEN}7)${FONT_DEFAULT} Instalar Minecraft Forge    ${FONT_GREEN}8)${FONT_DEFAULT} Instalar ModLoader";
	echo
	echo "${FONT_GREEN}Mods:${FONT_DEFAULT}"
	echo
	echo "   ${FONT_GREEN}9)${FONT_DEFAULT} Instalar Pixelmon          ${FONT_GREEN}10)${FONT_DEFAULT} Instalar Rei's Minimap";
	echo
	echo "${FONT_GREEN}Skins - Personagem:${FONT_DEFAULT}"
	echo
	echo "  ${FONT_GREEN}11)${FONT_DEFAULT} Instalar Mário             ${FONT_GREEN}12)${FONT_DEFAULT} Instalar Raphael";
	echo "  ${FONT_GREEN}13)${FONT_DEFAULT} Instalar Zumbi             ${FONT_GREEN}14)${FONT_DEFAULT} Instalar He-Man        ${FONT_GREEN}15)${FONT_DEFAULT} Original";
	echo
	echo "${FONT_GREEN}Controle:${FONT_DEFAULT}"
	echo
	echo "   ${FONT_RED}R)${FONT_DEFAULT} Rodar o jogo                ${FONT_RED}E)${FONT_DEFAULT} Encerrar o jogo         ${FONT_RED}L)${FONT_DEFAULT} Limpar esta tela";
	echo
	echo "${FONT_YELLOW}S)${FONT_DEFAULT} Sair";
	echo
	echo ":\c";

	read option

	if [ "$option" == "1" ] ; then doInstall;
	elif [ "$option" == "2" ] ; then doUninstall;
	elif [ "$option" == "3" ] ; then doCleanUpPersonalFolder;
	elif [ "$option" == "4" ] ; then doBackup;
	elif [ "$option" == "5" ] ; then doBackupRestore;
	elif [ "$option" == "6" ] ; then doUninstallAllMods;

	elif [ "$option" == "7" ] ; then doInstallMinecraftForge;
	elif [ "$option" == "8" ] ; then doInstallModLoader;

	elif [ "$option" == "9" ] ; then doInstallPixelmon;
	elif [ "$option" == "10" ] ; then doInstallReisMinimap;

	elif [ "$option" == "11" ] ; then doInstallSkinChar 1;
	elif [ "$option" == "12" ] ; then doInstallSkinChar 2;
	elif [ "$option" == "13" ] ; then doInstallSkinChar 3;
	elif [ "$option" == "14" ] ; then doInstallSkinChar 4;
	elif [ "$option" == "15" ] ; then doUninstallSkinChar;

	elif [ "$option" == "R" -o "$option" == "r" ] ; then doStartGame;
	elif [ "$option" == "E" -o "$option" == "e" ] ; then doQuitGame;
	elif [ "$option" == "L" -o "$option" == "l" ] ; then doClearScreen;

	elif [ "$option" == "S" -o "$option" == "s" ] ; then doQuit;

	else
		showMainMenu "${FONT_RED}Digite uma das opções válidas!${FONT_DEFAULT}"
	fi
	return;
}

doSetup;
showMainMenu;
