#include "teachersettings.h"
#include <QVariant>
#include <QFile>
#include <QDir>

TeacherSettings::TeacherSettings()
{

}

void TeacherSettings::fillFromFolder()
{
    QDir configFolder("teacherConfigurations");
    if(!configFolder.exists()){
        QDir().mkdir("teacherConfigurations");
        QDir configFolder("teacherConfigurations");
    }

    QStringList configList = configFolder.entryList(QDir::Files);
    for(auto config : configList)
        if(config.split('.').last() == "gtc"){
            config.resize(config.size()-4);
            emit addTeacherSetting(config);
        }
}

void TeacherSettings::addTeacher()
{
    QString newFileName = "Преподаватель";
    int suff = 1;
    QFile newSubjectSet("teacherConfigurations/" + newFileName + ".gtc");
    while(newSubjectSet.exists()){
        suff++;
        newSubjectSet.setFileName("teacherConfigurations/" + newFileName + " №" + QString::number(suff) + ".gtc" );
    }
    if(newSubjectSet.open(QIODevice::ReadWrite))
        newSubjectSet.write("Предмет-0");
    newSubjectSet.close();
    if(suff == 1)
        emit addNewTeacher(newFileName);
    else
        emit addNewTeacher(newFileName + " №" + QString::number(suff));
}

void TeacherSettings::showTeacherProfile(QVariant teacherName)
{
    QFile teacherProfileFile("teacherConfigurations/" + teacherName.toString() + ".gtc");
    if(teacherProfileFile.open(QIODevice::ReadOnly)){
        QByteArrayList profile = teacherProfileFile.readAll().split('\n');
        for(auto line : profile){
            if(!line.isEmpty())
                emit addTeacherProfileLine(line);
        }
    }
}

void TeacherSettings::saveTeacherProfile(QVariant teacherName, QVariant profile)
{
    QFile teacherProfileFile("teacherConfigurations/" + teacherName.toString() + ".gtc");
    if(teacherProfileFile.open(QIODevice::WriteOnly)){
        teacherProfileFile.write(profile.toByteArray());
    }
}

bool TeacherSettings::renameTeacher(QVariant lastName, QVariant newName)
{
    QFile subjectFile("teacherConfigurations/" + lastName.toString() + ".gtc");
    return subjectFile.rename("teacherConfigurations/" + newName.toString() + ".gtc");
}

void TeacherSettings::delTeacher(QVariant teacherName)
{
    QFile teacherProfileFile("teacherConfigurations/" + teacherName.toString() + ".gtc");
    teacherProfileFile.remove();
}

QVariant TeacherSettings::getSubjectProfiled(QVariant subject)
{
    QStringList teacherList;
    QDir configFolder("teacherConfigurations");
    QStringList configList = configFolder.entryList(QDir::Files);
    for(auto config : configList){
        QFile file("teacherConfigurations/" + config);
        if(file.open(QIODevice::ReadOnly)){
            QString str = file.readAll().toStdString().c_str();
            if(str.contains(subject.toString())){
                QString teacherName = config;
                teacherName.resize(teacherName.size()-4);
                teacherList.append(teacherName);
            }
        }
    }
    return teacherList;
}


