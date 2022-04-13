#include "mainsettings.h"
#include <QDir>
#include <QVariant>

MainSettings::MainSettings()
{

}

void MainSettings::fillFromFolder()
{
    QDir settingsFolder("settings");

    if(!settingsFolder.exists()){
        QDir().mkdir("settings");
    }

    if(!settingsFolder.entryList(QDir::Files).contains("main.gts"))
        recoverMainFile();

    QFile mainSettings("settings/main.gts");

    if(mainSettings.open(QIODevice::ReadWrite)){
        QByteArrayList mainSettingsList = mainSettings.readAll().split('\n');
        for(auto setting : mainSettingsList){
            if(!setting.contains('-'))
                continue;
            emit addMainSetting(setting.split('-').at(0).toStdString().c_str(),
                                setting.split('-').at(1).toStdString().c_str());
        }
    }

    QFile themeSettings("settings/theme.gts");

    if(themeSettings.open(QIODevice::ReadWrite)){
        emit setColorTheme(themeSettings.readAll().contains("DAY"));
    }

}

void MainSettings::saveSettings(QVariant settingsArray, QVariant savePath)
{
    QByteArray settingsToSave = settingsArray.toByteArray();
    if(savePath == "settings/main.gts")
        settingsToSave.remove(settingsArray.toByteArray().count()-1,1);

    QFile fileToSave(savePath.toString());
    if(fileToSave.open(QIODevice::WriteOnly)){
        fileToSave.write(settingsToSave);
    }
}

void MainSettings::saveThemeSetting(QVariant theme)
{
    QFile fileToSave("settings/theme.gts");
    if(fileToSave.open(QIODevice::WriteOnly)){
        fileToSave.write(theme.toByteArray());
    }
}

void MainSettings::recoverMainFile()
{
    QFile baseFile(":/others/main.gts");
    QFile newFile("settings/main.gts");
    if(baseFile.open(QIODevice::ReadOnly) && newFile.open(QIODevice::WriteOnly)){
        QByteArray data = baseFile.readAll();
        newFile.write(data);
    }

}
