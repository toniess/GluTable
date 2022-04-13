#include "homepage.h"
#include "tablemixer.h"

#include <QDir>
#include <QVariant>
#include <QMenu>
#include <QMenuBar>

#include <QFile>
//#include <QTableView>
#include <QDebug>
#include <QException>

HomePage::HomePage()
{

}

HomePage::~HomePage()
{
}

void HomePage::fillFromFolder()
{
    QDir tableFolder("tables");

    if(!tableFolder.exists()){
        QDir().mkdir("tables");
        return;
    }

    QStringList companyTablesList = tableFolder.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for(auto it : companyTablesList)
        emit addTable(it);
}

void HomePage::saveTable(QVariant companyTablePos, QVariant dataToSave)
{
    QString fileLink = "tables/" + currentTableName + "/" + QString::number(companyTablePos.toInt()) + ".gt";
    QFile companyTableFile(fileLink);

    QFile().remove(fileLink);

    if (companyTableFile.open(QIODevice::WriteOnly))
    {
        QStringList dataList = dataToSave.toStringList();
        companyTableFile.write(dataList.join("\n").toUtf8());
    }
    companyTableFile.close();
}

void HomePage::deleteTable(QVariant tableName)
{
    QString dirName = getLinkFromTableName(tableName.toString());
    QDir dir(dirName);
    if(dir.exists())
        dir.removeRecursively();
    emit clearWorkSpace();
    currentTableName = "";
}

void HomePage::addNewTable(QVariant tableName)
{
    emit clearWorkSpace();
    if(tableName != ""){
        QDir newTable("tables/" + tableName.toString());
        int i = 1;
        while(newTable.exists()){
            i++;
            newTable.setPath("tables/" + tableName.toString() + QString::number(i));
        }
        QDir().mkdir(newTable.path());
        currentTableName = newTable.dirName();
        emit setStatusBarName(currentTableName);
        addTable(currentTableName);
    }
}

bool HomePage::fillWorkSpace(QVariant tableName)
{
    if(tableName.toString() != currentTableName){
        emit clearWorkSpace();
        QDir table(getLinkFromTableName(tableName.toString()));

        currentTableName = tableName.toString();
        emit setStatusBarName(tableName.toString());

        table.setNameFilters(QStringList() << "*.gt");
        QStringList companyTablesList = table.entryList(QDir::Files);
        companyTablesList.sort();
        for(auto it : companyTablesList){
            int companyTablePos = it.split(".").first().toInt(nullptr);
            emit addCompanyTable(companyTablePos);
            fillWithTableItems(companyTablePos, table.path() + "/" + it);
        }
    }
    emit openEditPage();
}

void HomePage::fillWithTableItems(int companyTablePos, QString fileName)
{
    QStringList configList = getConfigList(fileName);
    for(auto line : configList){
        QStringList data = line.split("-");
        QString subj    = data.at(0);
        int widthSpan   = data.at(1).toInt(nullptr);
        int heightSpan  = data.at(2).toInt(nullptr);
        int bold        = data.at(3).toInt(nullptr);
        int row         = data.at(4).toInt(nullptr);
        int col         = data.at(5).toInt(nullptr);
        QString teacher = data.at(6);
        emit addTableItem(companyTablePos, subj, widthSpan, heightSpan, bold, row, col, teacher);
    }
}

void HomePage::createCompanyTable(QVariant companyTablePos)
{
    QStringList configList = getConfigList(":/others/standart_configuration.gtc");
    for(auto line : configList){
        QStringList data = line.split("-");
        QString subj    = data.at(0);
        int widthSpan   = data.at(1).toInt(nullptr);
        int heightSpan  = data.at(2).toInt(nullptr);
        int bold        = data.at(3).toInt(nullptr);
        int row         = data.at(4).toInt(nullptr);
        int col         = data.at(5).toInt(nullptr);
        QString teacher = data.at(6);
        emit addTableItem(companyTablePos.toInt(), subj, widthSpan, heightSpan, bold, row, col, teacher);
    }
}

void HomePage::addCompanyTableToFile(QVariant companyTablePos)
{
    QString newFileNme  = "tables/" + currentTableName + "/" + QString::number(companyTablePos.toInt()) + ".gt";
    QFile().copy(":/others/standart_configuration.gtc", newFileNme);
    addCompanyTable(companyTablePos.toInt());
    fillWithTableItems(companyTablePos.toInt(), newFileNme);
}

void HomePage::deleteCompanyTable(QVariant companyTablePos)
{
    QFile().remove("tables/" + currentTableName + "/" + QString::number(companyTablePos.toInt()) + ".gt");
}

bool HomePage::fileOpened()
{
    return currentTableName != "";
}

QStringList HomePage::getConfigList(QString fileName)
{
    QFile configFile(fileName);
    if(configFile.open(QIODevice::ReadOnly)){
        QString file = configFile.readAll();
        return file.split("\n");
    }
    throw "FILE OPEN ERROR";
    configFile.close();
}

QString HomePage::getTableNameFromLink(QString tableNameLink)
{
    return tableNameLink.split('.').first();
}
QString HomePage::getLinkFromTableName(QString tableName)
{
    return QString("tables/" + tableName);
}



