#include "subjectsettings.h"
#include <QDir>
#include <QDebug>
#include <QException>

SubjectSettings::SubjectSettings()
{

}

void SubjectSettings::fillFromFolder()
{
    QDir configFolder("subjectConfigurations");
    if(!configFolder.exists()){
        QDir().mkdir("subjectConfigurations");
        QDir configFolder("subjectConfigurations");
    }

    QStringList configList = configFolder.entryList(QDir::Files);
    for(auto config : configList)
        if(config.split('.').last() == "gtc")
            emit addSubject(config.split('.').first());
}

QString SubjectSettings::getLinkFromSubjectName(QString subjectName)
{
    return "subjectConfigurations/" + subjectName + ".gtc";
}

void SubjectSettings::saveSubjectSettings(QVariant subjectSettingsName, QVariant subjectSettingsArray)
{
    QFile subjectSettingsFile(getLinkFromSubjectName(subjectSettingsName.toString()));
    if(subjectSettingsFile.open(QIODevice::WriteOnly))
        subjectSettingsFile.write(subjectSettingsArray.toString().toUtf8());

    subjectSettingsFile.close();
}

void SubjectSettings::showSubjects(QVariant subjectName)
{
    QString a = getLinkFromSubjectName(subjectName.toString());
    QFile configurationFile(a);

    if(configurationFile.open(QIODevice::ReadOnly)){

        QByteArrayList subjectSettings = configurationFile.readAll().split('\n');

        for(auto setting : subjectSettings)
            if(setting.contains('-'))
                emit addSubjectSetting(QString(setting.split('-').first()), QString(setting.split('-').at(1)));
    }
}

void SubjectSettings::fillTableCollumn(QVariant subjectName, QVariant table, QVariant collumn)
{

    QString a = getLinkFromSubjectName(subjectName.toString());
    QFile configurationFile(a);

    if(configurationFile.open(QIODevice::ReadOnly)){
        QByteArrayList subjectSettings = configurationFile.readAll().split('\n');
        QStringList subjectList;

        for(auto setting : subjectSettings){
            QString subject = QString(setting.split('-').first());
            int times = QString(setting.split('-').at(1)).toInt(nullptr);

            for(int i = 0; i < times; i++){
                subjectList.append(subject);
            }

        }
        emit setTableCollumn(table, collumn, subjectList);
    }
}

QVariant SubjectSettings::getSubjectDb()
{
    QFile fileDB("dataBases/subjects.gtc");
    QVariant list = {};
    if(fileDB.open(QIODevice::ReadWrite)){
        QString subjectDb = fileDB.readAll().toStdString().c_str();
        list = subjectDb.split('\n');
    }
    return list;
}

void SubjectSettings::addNewSubjectSet()
{
    QString newFileName = "Набор предметов";
    int suff = 1;
    QFile newSubjectSet(getLinkFromSubjectName(newFileName));
    while(newSubjectSet.exists()){
        suff++;
        newSubjectSet.setFileName(getLinkFromSubjectName(newFileName + " №" + QString::number(suff)));
    }
    if(newSubjectSet.open(QIODevice::ReadWrite))
        newSubjectSet.write("Предмет-0");
    newSubjectSet.close();
    if(suff == 1)
        emit addSubject(newFileName);
    else
        emit addSubject(newFileName + " №" + QString::number(suff));
}

bool SubjectSettings::renameSubjectSet(QVariant lastName, QVariant newName)
{
    QFile subjectFile(getLinkFromSubjectName(lastName.toString()));
    return subjectFile.rename(getLinkFromSubjectName(newName.toString()));
}

void SubjectSettings::deleteSubjectSet(QVariant subjectSettingName)
{
    QFile subjectFile(getLinkFromSubjectName(subjectSettingName.toString()));
    subjectFile.remove();
}
