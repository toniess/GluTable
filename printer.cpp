#include "printer.h"
#include <QVariant>
#include <QFile>
#include <QDir>
#include <QTextDocument>
#include <QPrinter>
#include <QFileDialog>

Printer::Printer()
{

}

void Printer::setData(QVariant data)
{
    this->data += data.toStringList();
    companyCount ++;
}

void Printer::distribute()
{
    int comp = 0;
    int platoon = 0;
    int lesson = 0;
    for(int i = 0; i < data.count(); i += 2){
            table[comp][platoon][lesson][0] = data.at(i);
            table[comp][platoon][lesson][1] = data.at(i+1);
        lesson ++;
        if(lesson == 36){
            lesson = 0;
            platoon ++;
        }
        if(platoon == 4){
            platoon = 0;
            comp++;
        }

        if(comp == companyCount)
            break;
    }
    data.clear();
}

void Printer::printData()
{
    distribute();
    QString time = QDate::currentDate().toString() + " " + QTime::currentTime().toString();

    QDir tableFolder(time);

    if(!tableFolder.exists()){
        QDir().mkdir(time);
    }

    QFile htmlFile(":/others/code.html");
    QString htmlFileData;

    if(htmlFile.open(QIODevice::ReadOnly)){
        QFile file;
        htmlFileData = htmlFile.readAll();
        for(int i = 0; i < companyCount; i++){
            QString htmlCode = htmlFileData;
            file.setFileName(savePath + time + "/" + QString::number(i + 1) + ".html");
            for(int platoon = 0; platoon < 4; platoon++)
                for(int line = 0; line < 36; line++)
                    htmlCode.replace(QString::number(platoon + 1) + " " + QString::number(line + 1) + "<",
                                     table[i][platoon][line][0] + "<");

            if(file.open(QIODevice::WriteOnly)){
                file.write(htmlCode.toUtf8());
                file.close();
            }
        }
    }
    companyCount = 0;
}

void Printer::printTeachersData()
{
    distribute();
    fillTeachersMap();

    QString time = QDate::currentDate().toString() + " " + QTime::currentTime().toString();

    QDir tableFolder(time);

    if(!tableFolder.exists()){
        QDir().mkdir(time);
    }
    QFile htmlFile(":/others/teacherCode.html");
    QString htmlFileData;
    if(htmlFile.open(QIODevice::ReadOnly))
            htmlFileData = htmlFile.readAll();
    QFile file;
    for(auto line : teachersMap){
        QString code = htmlFileData;
        code.replace("teacherName", line.first);
        for(int i = 0; i < line.second.count(); i++)
            code.replace("1 " + QString::number(i + 1) + "<", line.second.at(i) + "<");
        file.setFileName(savePath + time + "/" + line.first + ".html");
        if(file.open(QIODevice::WriteOnly)){
            file.write(code.toUtf8());
            file.close();
        }
    }

    companyCount = 0;
}

void Printer::chooseSavePath()
{
    //    savePath = QFileDialog::getExistingDirectory(nullptr, tr("Экспорт"), QDir::homePath()) + "/";
}

void Printer::fillTeachersMap()
{
    teachersMap.clear();
    for(int company = 0; company < companyCount; company++){
        for(int platoon = 0; platoon < 4; platoon ++){
            for(int line = 0; line < 36; line++){
                QString teacherName = table[company][platoon][line][1];
                if(teacherName == "Нет преподавателя") continue;
                if(teachersMap.find(teacherName) == teachersMap.end()){
                    QStringList *list = new QStringList;
                    list->reserve(36);
                    teachersMap.emplace(teacherName, *list);
                }
                teachersMap.at(teacherName)[line] = QString::number(company + 1) + " Рота " + QString::number(platoon + 1) + " Взвод";
            }
        }
    }
}
