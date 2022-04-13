#ifndef CABINETSSETTINGS_H
#define CABINETSSETTINGS_H

#include <QDebug>
#include <QObject>
#include <QVariant>
#include <map>
using namespace std;

class CabinetsSettings: public QObject
{
    Q_OBJECT
private:
    map<QString, QStringList> profileViewData;
    map<QString, QStringList> cabinetsViewData;
    void fillCabinetMapFromProfile();
    void fillProfileMapFromCabinet();
    void saveSettings();
public:
    CabinetsSettings();
    void fillFromFolder();
public slots:
    void showProfileSubjects(QVariant isProfile, QVariant cabinet);
    void updateData(QVariant isProfile, QVariant key, QVariant dataArr);
    void delSetting(QVariant isProfile, QVariant key);
    void addSetting(QVariant isProfile);
    void changeView(QVariant isProfile);
    bool renameData(QVariant isProfile, QVariant lastKey, QVariant newKey);

signals:
    void addCabinetViewSetting(QString cabinetSubject);
    void setDataList(QString);
};

#endif // CABINETSSETTINGS_H
