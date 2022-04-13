#ifndef TABLEMIXER_H
#define TABLEMIXER_H

#include <QThread>
#include <QVariant>
#include <QTimer>
#include <map>
#include <iostream>

using namespace std;

#ifdef Q_OS_MAC
#define RANDOM arc4random()
#else
#define RANDOM random()
#endif

struct PE_Struct{
    QVector<int> data[4];
    void append(int platoon, int index){
        data[platoon].append(index);
    }
};

class TableMixer : public QThread
{
     Q_OBJECT

public:

    TableMixer();
    void run();
    QTimer *timer;
    bool isSimple;
    bool needToStop = false;


public slots:
    void inizialize(QVariant tableData, QVariant isSimple);
    void makeUpWarnings(QVariant rowData, QVariant row);
    void setCompanyData(QVariant tableId, QVariant companyData);
    void stopThread();

private:
    bool isComfortToPass(int comp, int  platoon, int rowPlace, int rowPass, bool isDown);
    bool isLineFree(int row, QString teacher, int currentComp, int currentPlatoon);
    bool setSinglePE(int comp, int platoon, int index, QVector<int> suitRowsPE);
    bool tryToFindItDown(QStringList *array, int comp, int platoon, int row);
    bool tryToFindItUp(QStringList *array, int comp, int platoon, int row);
    bool toDoubleSubject(int comp, int platoon, int row1, int row2);
    bool canSwapNoPE(int comp, int platoon, int row1, int row2);
    bool canSwap(int comp, int platoon, int row1, int row2);
    bool isTeacherWorks(int row, QString teacherName);
    bool isArrayUnic(QStringList array);
    bool isCurrectRow(int row);
    bool mergeSimilar();
    bool isTableCanBe();
    bool checkWindow();
    bool noTrice();
    bool flag = 1;

    void printTables(QString path);

    void swapTableItems(int comp, int platoon, int row1, int row2);
    void getTeacherTimeTable(QString teacherName);
    void fillFromTableStruct();
    void distributeForTable();
    void fillTeacherList();
    void rememberCurrentTable();
    void copyBestToTable(int bestTableIndex);
    void fixEmptyItems();
    void randSwapping();
    void clearStruct();
    void complexMix();
    void simpleMix();

    int countInList(QStringList list, QString str);
    int lookForEmptyItem(int comp, int platoon, int row);
    int makeUpPE(QVector<PE_Struct> rowPE);
    int getBestTableIndex();
    int getTableQuality(int memoryIndex);
    int companyCount;

    QVector<int> getSuitRows(int day);

    QString table [7][4][36][4];
    QVector< QVector< QVector< QVector< QVector< QString >>>>> tableMemory;
    int currentQuality = 0;
    bool teacherTimeTable[6][6];
    QStringList teacherList;
    QStringList data;

signals:
    void setTableItem(QVariant table, QVariant subject, QVariant teacher, QVariant row, QVariant col, QVariant thatsAll);
    void setWarning(QVariant comp, QVariant platoon, QVariant lesson, QVariant isWarning);
    void showMessage(QString header, QString message);
    void noTriceSubj(QVariant a);
    void stopLoading();
};

#endif // TABLEMIXER_H
