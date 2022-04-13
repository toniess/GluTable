#ifndef PRINTER_H
#define PRINTER_H

#include <QObject>
#include <QWidget>
#include <QVariant>
#include <QDateTime>
#include <map>

using namespace std;

class Printer : public QObject
{
    Q_OBJECT
public:
    Printer();
public slots:
    void setData(QVariant data);
    void printData();
    void printTeachersData();
    void chooseSavePath();
private:
    map<QString, QStringList> teachersMap;
    void fillTeachersMap();
    QString savePath = "";
    QStringList data;
    void distribute();
    QString table[7][4][36][2];
    int companyCount = 0;
};

#endif // PRINTER_H
