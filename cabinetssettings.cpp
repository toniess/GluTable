#include "cabinetssettings.h"
#include <QDir>
#include <QFile>
#include <map>
using namespace std;

CabinetsSettings::CabinetsSettings()
{

}

void CabinetsSettings::fillFromFolder()
{
    QFile cabinetsConfigFile("settings/cabinetsSettings.gtc");
    if(cabinetsConfigFile.open(QIODevice::ReadWrite)){
        if(!cabinetsConfigFile.readAll().contains('-'))
            return;
        QByteArrayList config = cabinetsConfigFile.readAll().split('\n');
        for(auto line : config){
            QString subjectProfile = line.split('-').first();
            QString cabinets = line.split('-').last();
            QStringList cabinetsList = cabinets.split(',');

            profileViewData.emplace(subjectProfile, cabinetsList);

            for(auto cabinet : cabinetsList){
                if(cabinetsViewData.find(cabinet) == cabinetsViewData.end()){
                    QStringList list;
                    list.push_back(subjectProfile);
                    cabinetsViewData.emplace(cabinet, subjectProfile);
                }else{
                    cabinetsViewData.at(cabinet).push_back(subjectProfile);
                }
            }
        }
    }
    for(auto line : cabinetsViewData){
        emit addCabinetViewSetting(line.first);
    }
}

void CabinetsSettings::showProfileSubjects(QVariant isProfile, QVariant cabinet)
{
    qDebug() << "";
    auto *viewData = isProfile.toBool()? &profileViewData : &cabinetsViewData;
    for(auto it : viewData->at(cabinet.toString()))
        emit setDataList(it);
    saveSettings();
}

void CabinetsSettings::updateData(QVariant isProfile, QVariant key, QVariant dataArr)
{
    auto *viewData = isProfile.toBool()? &profileViewData : &cabinetsViewData;
    viewData->at(key.toString()) = dataArr.toStringList();
    isProfile.toBool()? fillCabinetMapFromProfile() : fillProfileMapFromCabinet();
    saveSettings();
}

void CabinetsSettings::delSetting(QVariant isProfile, QVariant key)
{
    auto *viewData = isProfile.toBool()? &profileViewData : &cabinetsViewData;
    viewData->erase(key.toString());
    isProfile.toBool()? fillCabinetMapFromProfile() : fillProfileMapFromCabinet();
    saveSettings();
}

void CabinetsSettings::addSetting(QVariant isProfile)
{
    auto *viewData = isProfile.toBool()? &profileViewData : &cabinetsViewData;
    QString text = isProfile.toBool()? "Предмет" : "Кабинет";
    int it = 1;
    QString name = text + " " + QString::number(it);
    while(viewData->find(name) != viewData->end()){
        it++;
        name = text + " " + QString::number(it);
    }
    QStringList list;
    viewData->emplace(name, list);
    saveSettings();
    emit addCabinetViewSetting(name);
}

void CabinetsSettings::changeView(QVariant isProfile)
{
    isProfile.toBool()? fillCabinetMapFromProfile() : fillProfileMapFromCabinet();
    saveSettings();
    for(auto line : (isProfile.toBool()? profileViewData : cabinetsViewData))
        emit addCabinetViewSetting(line.first);
}

bool CabinetsSettings::renameData(QVariant isProfile, QVariant lastKey, QVariant newKey)
{
    auto *viewData = isProfile.toBool()? &profileViewData : &cabinetsViewData;
    if(viewData->find(newKey.toString()) != viewData->end())
        return false;
    QStringList list = viewData->at(lastKey.toString());
    viewData->erase(lastKey.toString());
    viewData->emplace(newKey.toString(), list);
    isProfile.toBool()? fillCabinetMapFromProfile() : fillProfileMapFromCabinet();
    saveSettings();
    return true;
}

void CabinetsSettings::fillCabinetMapFromProfile()
{
    cabinetsViewData.clear();
    for(auto line : profileViewData){

        QString subjectProfile   = line.first;
        QStringList cabinetsList = line.second;

        for(auto cabinet : cabinetsList){
            if(cabinetsViewData.find(cabinet) == cabinetsViewData.end()){
                QStringList list;
                list.push_back(subjectProfile);
                cabinetsViewData.emplace(cabinet, list);
            }else{
                cabinetsViewData.at(cabinet).push_back(subjectProfile);
            }
        }
    }
}

void CabinetsSettings::fillProfileMapFromCabinet()
{
    profileViewData.clear();
    for(auto line : cabinetsViewData){

        QString cabinet                   = line.first;
        QStringList subjectsProfileList   = line.second;

        for(auto subject : subjectsProfileList){
            if(profileViewData.find(subject) == profileViewData.end()){
                QStringList list;
                list.push_back(cabinet);
                profileViewData.emplace(subject, list);
            }else{
                profileViewData.at(subject).push_back(cabinet);
            }
        }
    }
}

void CabinetsSettings::saveSettings()
{
    QFile cabinetsConfigFile("settings/cabinetsSettings.gtc");
    if(cabinetsConfigFile.open(QIODevice::WriteOnly)){
        QByteArray writeData;
        for(auto line : profileViewData){
            writeData.append(QString(line.first + "-").toUtf8());
            for(auto cab : line.second)
                writeData.append(QString(cab + ',').toUtf8());
            writeData.resize(writeData.size() - 1);
            writeData.append('\n');
        }
        writeData.resize(writeData.size() - 1);
        cabinetsConfigFile.write(writeData);
    }
    cabinetsConfigFile.close();
}
