#ifndef MAINSETTINGS_H
#define MAINSETTINGS_H

#include <QObject>
#include <QVariant>

class MainSettings : public QObject
{
    Q_OBJECT
public:
    MainSettings();
    void fillFromFolder();
public slots:
    void saveSettings(QVariant settingsArray, QVariant savePath);
    void saveThemeSetting(QVariant theme);
private:
    void recoverMainFile();
signals:
    void addMainSetting(QVariant settingName, QVariant settingValue);
    void setColorTheme(QVariant isDay);
    void saveApp();
};

#endif // MAINSETTINGS_H
