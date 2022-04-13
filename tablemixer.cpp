#include "tablemixer.h"
#include "homepage.h"
#include <QDebug>
#include <QVariant>
#include <QException>
#include <QTime>
#include <QDir>

TableMixer::TableMixer()
{
    setTerminationEnabled(true);
}


void TableMixer::inizialize(QVariant companyCount, QVariant isSimple)
{
//    data = tableData.toStringList();

    this->isSimple = isSimple.toBool();
    this->companyCount = companyCount.toInt();
    this->setTerminationEnabled(true);
    needToStop = false;
}

void TableMixer::stopThread()
{
    needToStop = true;
}

void TableMixer::makeUpWarnings(QVariant rowData, QVariant row)
{
    QStringList data = rowData.toStringList();
    bool mark;
    bool isWarning = false;
    for(int index = 0; index < data.count(); index++){
        mark =  countInList(data, data.at(index)) > 1 && !data.at(index).contains("Нет преподавател");
        if(mark)
            isWarning = true;

        emit setWarning(index / 4, index % 4 + 2, row.toInt(), mark);
    }
    emit setWarning(0, 1, row.toInt(), isWarning);
    emit setWarning(1, 1, row.toInt(), isWarning);
    emit setWarning(2, 1, row.toInt(), isWarning);
}

void TableMixer::setCompanyData(QVariant tableId, QVariant companyData)
{
    data += companyData.toStringList();

    if(tableId == companyCount - 1){
        this->start(QThread::HighestPriority);
    }
}

void TableMixer::run()
{
    distributeForTable();

    fixEmptyItems();

    fillTeacherList();

    randSwapping();

    isSimple? simpleMix() : complexMix();


    if(needToStop){
        emit stopLoading();
        return;
    }

    fillFromTableStruct();
    teacherList.clear();


}

bool TableMixer::tryToFindItUp(QStringList *array, int comp, int platoon, int currentRow)
{
    for(int row = currentRow + 1; row < 36; row++)
        if(!array->contains(table[comp][platoon][row][1])
                && table[comp][platoon][row][1] != "Нет преподавателя"
                && isComfortToPass(comp, platoon, currentRow, row, false)){
            array->push_back(table[comp][platoon][row][1]);
            swap(table[comp][platoon][row][1], table[comp][platoon][currentRow][1]);
            swap(table[comp][platoon][row][0], table[comp][platoon][currentRow][0]);
            return true;
        }
    return false;
}

bool TableMixer::tryToFindItDown(QStringList *array, int comp, int platoon, int currentRow)
{
    for(int row = currentRow - 1; row >= 0; row--)
        if(!array->contains(table[comp][platoon][row][1])
                && isLineFree(row, table[comp][platoon][currentRow][1], comp, platoon)
                && isComfortToPass(comp, platoon, currentRow, row, false) &&
                   isComfortToPass(comp, platoon, row, currentRow, true) ){
            array->push_back(table[comp][platoon][row][1]);
            swap(table[comp][platoon][row][1], table[comp][platoon][currentRow][1]);
            swap(table[comp][platoon][row][0], table[comp][platoon][currentRow][0]);
            return true;
        }
    return false;
}

bool TableMixer::isArrayUnic(QStringList array)
{
    for(int i = 0; i < array.count(); i++){
        if(array.count(array.at(i)) > 1)
            return false;
    }
    return true;
}

int TableMixer::countInList(QStringList list, QString str)
{
    int count = 0;
    for(int i = 0; i < list.count(); i++)
        if(count == 2)
            return count;
        else count += list.at(i) == str? 1 : 0;
    return count;
}

bool TableMixer::noTrice()
{
    for(int comp = 0; comp < companyCount; comp++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int day = 0; day < 6; day++)
                for(int subj = day * 6; subj < day * 6 + 6; subj++){
                    int many = 1;
                    QString s = table[comp][platoon][subj][1];
                    for(int row = subj+1; row < day * 6 + 6; row++){
                        many += table[comp][platoon][row][1] == s? 1 : 0;
                        if(many == 3)
                            return false;
                    }
                }
    return true;
}

void TableMixer::printTables(QString path)
{
    QString time = QDate::currentDate().toString() + " " + QTime::currentTime().toString();

    QDir tableFolder(time);

    if(!tableFolder.exists()){
        QDir().mkdir(time);
    }

    QFile htmlFile("code.html");
    QString htmlFileData;

    if(htmlFile.open(QIODevice::ReadOnly)){

        QFile file;
        htmlFileData = htmlFile.readAll();
        for(int i = 0; i < companyCount; i++){
            QString htmlCode = htmlFileData;
            file.setFileName(path + "/" + time + "/" + QString::number(i + 1) + ".html");
            for(int platoon = 0; platoon < 4; platoon++)
                for(int line = 0; line < 36; line++)
                    htmlCode.replace(QString::number(platoon + 1) + " " + QString::number(line + 1) + "<", table[i][platoon][line][0] + "<");

            if(file.open(QIODevice::WriteOnly)){
                file.write(htmlCode.toUtf8());
                file.close();
            }
        }
    }
}

bool TableMixer::checkWindow()
{
    for(auto teacherName : teacherList) {
        getTeacherTimeTable(teacherName);
        int a = 0;
        int weekLessons = 0;
        for(int day = 0; day < 6; day ++){
            int lessonCount = 0;

            for(int lesson = 5; lesson >= 0; lesson --){
                if(teacherTimeTable[day][lesson]){
                    lessonCount++;
                    weekLessons++;
                }
            }
            if(lessonCount == 1)
                a++;
        }
        if((a > 0 && weekLessons > 15)  ||  (a > 1 && weekLessons > 12))
            return false;
    }
    return true;
}

void TableMixer::getTeacherTimeTable(QString teacherName)
{
    for(int row = 0; row < 36; row ++)
        teacherTimeTable[row / 6][row % 6] = isTeacherWorks(row, teacherName);
}

bool TableMixer::isTeacherWorks(int row, QString teacherName)
{
    for(int comp = 0; comp < companyCount; comp ++)
        for(int platoon = 0; platoon < 4; platoon++)
            if(table[comp][platoon][row][1] == teacherName)
                return true;
    return false;
}

bool TableMixer::isComfortToPass(int comp, int platoon, int rowPlace, int rowPass, bool isDown)
{
    int downRow = rowPlace / 6 * 6;
    int upRow   = downRow + 6;
    QString subject = table[comp][platoon][rowPass][0];
    int many = 0;
    int border = isDown? upRow : rowPlace;
    for(int curRow = downRow; curRow < border; curRow++){
        if(table[comp][platoon][curRow][0] == subject)
            many++;
        if(many == 2)
            return false;
    }
    return true;
}

int TableMixer::lookForEmptyItem(int comp, int platoon, int row)
{
    for(int i = row + 1; i < 36; i++)
        if(table[comp][platoon][i][1] == "Нет преподавателя")
            return i;
    return -1;
}

QVector<int> TableMixer::getSuitRows(int day)
{
    QVector<int> suitRows;

    int index = day + 3;
    if(index <= 5 && index >= 0)
        suitRows.push_front(index);
    index = day - 3;
    if(index <= 5 && index >= 0)
        suitRows.push_front(index);
    index = day + 2;
    if(index <= 5 && index >= 0)
        suitRows.push_back(index);
    index = day - 2;
    if(index <= 5 && index >= 0)
        suitRows.push_back(index);

    return suitRows;
}

void TableMixer::randSwapping()
{
    srand(time(NULL));

    for(int comp = 0; comp < companyCount; comp ++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int i = 0; i < 20; i++){
                int row = RANDOM % 36, specRow = RANDOM % 36;
                if(table[comp][platoon][row][1] != "Нет преподавателя"
                        && table[comp][platoon][specRow][1] != "Нет преподавателя"){
                    swap(table[comp][platoon][row][1], table[comp][platoon][specRow][1]);
                    swap(table[comp][platoon][row][0], table[comp][platoon][specRow][0]);
                }
            }
}

void TableMixer::clearStruct()
{
    for(int comp = 0; comp < companyCount; comp ++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int row = 0; row < 35; row ++)
                for(int i = 0; i  < 4; i ++)
                    table[comp][platoon][row][i].clear();
    for(int i = 0; i < 6; i++)
        for(int j = 0; j < 6; j++)
            teacherTimeTable[i][j] = false;
}

void TableMixer::complexMix()
{
    int time = QTime::currentTime().second() + QTime::currentTime().minute()*60;
    while(true){
        randSwapping();
        QStringList array;

        for(int row = 0; row < 36; row ++){
          array.clear();
          for(int comp = 0; comp < companyCount; comp++)
             for(int platoon = 0; platoon < 4; platoon ++){
                 if((!array.contains(table[comp][platoon][row][1])
                     || table[comp][platoon][row][1] == "Нет преподавателя")
                         && isComfortToPass(comp, platoon, row, row, false))
                     array.push_back(table[comp][platoon][row][1]);
                  else
                     if(!tryToFindItUp(&array, comp, platoon, row))
                         tryToFindItDown(&array, comp, platoon, row);
             }
        }

        QVector<PE_Struct> rowPE(companyCount);

        for(int comp = 0; comp < companyCount; comp ++)
            for(int platoon = 0; platoon < 4; platoon ++)
                for(int row = 0; row < 36; row ++){
                    if(table[comp][platoon][row][0] == "Физра")
                        rowPE[comp].data[platoon].append(row);
                    if(row == 35 && rowPE[comp].data[platoon].count() != 3){
                        needToStop = true;
                        comp = 2; platoon = 3;
                        QString message = "Недостаточно уроков физкультуры";
                        emit showMessage("Ошибка!",message);
                        break;
                  }
            }

        if(needToStop){
          break;
        }

        if((makeUpPE(rowPE) == companyCount * 4 && noTrice() && isTableCanBe())){
            rememberCurrentTable();
        }

        if(QTime::currentTime().second() + QTime::currentTime().minute()*60 - time > 30){
            break;
        }
    }
    int bestTableIndex = getBestTableIndex();
    copyBestToTable(bestTableIndex);
}

int TableMixer::getBestTableIndex()
{
    QPair<int, int> bestTable;
    for(int i = 0; i < tableMemory.count(); i++){
        int quality = getTableQuality(i);
        if(quality > bestTable.second){
            bestTable = qMakePair(i, quality);
        }
    }
    return bestTable.first;
}

int TableMixer::getTableQuality(int memoryIndex)
{
    auto currentTable = tableMemory.at(memoryIndex);

    int qualityMark = 0;
    for(int comp = 0; comp < companyCount; comp++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int day = 0; day < 6; day++)
                for(int subj = day * 6; subj < day * 6 + 6; subj++){
                    int row1 = subj;
                    QString s = currentTable[comp][platoon][subj][0];
                    for(int row = subj + 1; row < day * 6 + 6; row++){
                        if(currentTable[comp][platoon][row][0] == s){
                                if(!(abs(row1 - row) > 1 && !toDoubleSubject(comp, platoon, row1, row)))
                                    qualityMark++;
                        }
                    }
                }

    for(auto teacherName : teacherList) {
        getTeacherTimeTable(teacherName);
        for(int day = 0; day < 6; day ++){
            int lessonCount = 0;

            for(int lesson = 5; lesson >= 0; lesson --){
                if(teacherTimeTable[day][lesson]){
                    lessonCount++;
                }
            }
            qualityMark += lessonCount > 3? 1 : 0;
        }
    }
    return qualityMark;
}

void TableMixer::simpleMix()
{

    while(!needToStop){
        randSwapping();

        QStringList array;

        for(int row = 0; row < 36; row ++){
            array.clear();
            for(int comp = 0; comp < companyCount; comp++)
               for(int platoon = 0; platoon < 4; platoon ++){
                   if((!array.contains(table[comp][platoon][row][1])
                       || table[comp][platoon][row][1] == "Нет преподавателя")
                           && isComfortToPass(comp, platoon, row, row, false))
                       array.push_back(table[comp][platoon][row][1]);
                    else
                       if(!tryToFindItUp(&array, comp, platoon, row))
                           tryToFindItDown(&array, comp, platoon, row);
               }
        }

        QVector<PE_Struct> rowPE(companyCount);

        for(int comp = 0; comp < companyCount; comp ++)
            for(int platoon = 0; platoon < 4; platoon ++)
                for(int row = 0; row < 36; row ++){
                    if(table[comp][platoon][row][0] == "Физра")
                        rowPE[comp].append(platoon, row);
                    if(row == 35 && rowPE[comp].data[platoon].count() != 3){
                        needToStop = true;
                        comp = 2; platoon = 3;
                        QString message = "Недостаточно уроков физкультуры";
                        emit showMessage("Ошибка!",message);
                        break;
                    }
                }

        if(needToStop || (makeUpPE(rowPE) >= companyCount * 4 && !isTableCanBe() && noTrice() && mergeSimilar()/* && checkWindow()*/))
            break;
    }

}

void TableMixer::distributeForTable()
{
    int comp = 0;
    int platoon = 0;
    int lesson = 0;
    for(int i = 0; i < data.count(); i += 4){
            table[comp][platoon][lesson][0] = data.at(i);
            table[comp][platoon][lesson][1] = data.at(i+1);
            table[comp][platoon][lesson][2] = data.at(i+2);
            table[comp][platoon][lesson][3] = data.at(i+3);
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

void TableMixer::fillTeacherList()
{
    teacherList.clear();
    for(int comp = 0; comp < companyCount; comp ++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int row = 0; row < 36; row ++)
                if(!teacherList.contains(table[comp][platoon][row][1])
                        && table[comp][platoon][row][1] != "Нет преподавателя")
                    teacherList.append(table[comp][platoon][row][1]);
}

void TableMixer::rememberCurrentTable()
{
    QVector<QVector<QVector<QVector<QString>>>> compV;
    for(int comp = 0; comp < companyCount; comp ++){
        QVector<QVector<QVector<QString>>> platoonV;
        for(int platoon = 0; platoon < 4; platoon++){
            QVector<QVector<QString>> lessonV;
            for(int lesson = 0; lesson < 36; lesson++){
                QVector<QString> indexV;
                for(int index = 0; index < 4; index++){
                    indexV.append(table[comp][platoon][lesson][index]);
                }
                lessonV.append(indexV);
            }
            platoonV.append(lessonV);
        }
        compV.append(platoonV);
    }

    tableMemory.append(compV);
}

void TableMixer::copyBestToTable(int bestTableIndex)
{
    auto bestTable = tableMemory.at(bestTableIndex);

    for(int comp = 0; comp < companyCount; comp ++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int lesson = 0; lesson < 36; lesson ++)
                for(int index = 0; index < 4; index ++)
                    table[comp][platoon][lesson][index] = bestTable[comp][platoon][lesson][index];
}

void TableMixer::fixEmptyItems()
{
    for(int comp = 0; comp < companyCount; comp ++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int row = 0; row < 36; row++){
                if(table[comp][platoon][row][1] == "Нет преподавателя"){
                    swap(table[comp][platoon][row][1], table[comp][platoon][5][1]);
                    swap(table[comp][platoon][row][0], table[comp][platoon][5][0]);
                }
            }
}

void TableMixer::fillFromTableStruct()
{
    for(int comp = 0; comp < companyCount; comp++)
        for(int j = 0; j < 4; j++)
              for(int i = 0; i < 36; i++){
                  emit setTableItem(comp, table[comp][j][i][0], table[comp][j][i][1], table[comp][j][i][2], table[comp][j][i][3], comp == companyCount - 1);
              }
}

bool TableMixer::mergeSimilar()
{
    int fails = 0, succuss = 0;
    for(int comp = 0; comp < companyCount; comp++)
        for(int platoon = 0; platoon < 4; platoon ++)
            for(int day = 0; day < 6; day++)
                for(int subj = day * 6; subj < day * 6 + 6; subj++){
                    int row1 = subj;
                    QString s = table[comp][platoon][subj][0];
                    for(int row = subj + 1; row < day * 6 + 6; row++){
                        if(table[comp][platoon][row][0] == s){
                                if(abs(row1 - row) > 1 && !toDoubleSubject(comp, platoon, row1, row))
                                    fails++;
                                else
                                    succuss++;
                        }
                    }
                }
    if(fails == 0)
        return true;
    return succuss/fails > 3;
}

bool TableMixer::toDoubleSubject(int comp, int platoon, int row1, int row2)
{
    int bottom = row1 / 6 * 6;
    int top    = bottom + 5;
    for(int i = bottom; i < top; i += 2){
        if(canSwapNoPE(comp, platoon, row1, i) && canSwapNoPE(comp, platoon, row2, i + 1)){
            swapTableItems(comp, platoon, row1, i);
            swapTableItems(comp, platoon, row2, i + 1);
            return true;

        }
        if(canSwapNoPE(comp, platoon, row1, i + 1) && canSwapNoPE(comp, platoon, row2, i)){
            swapTableItems(comp, platoon, row1, i + 1);
            swapTableItems(comp, platoon, row2, i);
            return true;
        }
    }
    return false;
}

int TableMixer::makeUpPE(QVector<PE_Struct> rowPE)
{

    int countMergedPE = 0;
    int firstPEIndex;
    int secondPEIndex;
    int thirdPEIndex;
    for(int comp = 0; comp < companyCount; comp++)
        for(int platoon = 0; platoon < 4; platoon ++){
            try {
                if(rowPE[comp].data[platoon].count() > 2){
                    firstPEIndex = rowPE[comp].data[platoon].at(0);
                    secondPEIndex = rowPE[comp].data[platoon].at(1);
                    thirdPEIndex = rowPE[comp].data[platoon].at(2);
                }
            }  catch (...) {
                needToStop = true;
                return 0;
            }

            for(int row = 0; row < 35; row += 2){
                if(canSwap(comp, platoon, firstPEIndex, row) && canSwap(comp, platoon, secondPEIndex, row + 1)){
                    swapTableItems(comp, platoon, firstPEIndex, row);
                    swapTableItems(comp, platoon, secondPEIndex, row + 1);
                    int day = row / 6;
                    QVector<int> suitRows = getSuitRows(day);
                    if(!setSinglePE(comp, platoon, thirdPEIndex, suitRows))
                        return 0;
                    countMergedPE ++;
                    break;
                }
            }
        }
    return countMergedPE;
}

void TableMixer::swapTableItems(int comp, int platoon, int row1, int row2)
{
    swap(table[comp][platoon][row1][0], table[comp][platoon][row2][0]);
    swap(table[comp][platoon][row1][1], table[comp][platoon][row2][1]);
}

bool TableMixer::canSwap(int comp, int platoon, int row1, int row2)
{
    if(table[comp][platoon][row1][1] == "Нет преподавателя"
    || table[comp][platoon][row2][1] == "Нет преподавателя")
        return false;


    swap(table[comp][platoon][row1][0], table[comp][platoon][row2][0]);
    swap(table[comp][platoon][row1][1], table[comp][platoon][row2][1]);

    bool result = isCurrectRow(row1) && isCurrectRow(row2);

    swap(table[comp][platoon][row1][0], table[comp][platoon][row2][0]);
    swap(table[comp][platoon][row1][1], table[comp][platoon][row2][1]);

    return result;
}

bool TableMixer::isCurrectRow(int row)
{
    QStringList array;
    array.clear();
    for(int comp = 0; comp < companyCount; comp++)
        for(int platoon = 0; platoon < 4; platoon++){
            QString teacher = table[comp][platoon][row][1];
            if(!array.contains(teacher) || teacher == "Нет преподавателя")
                array.push_back(teacher);
            else
                return false;
        }
    return true;
}

bool TableMixer::setSinglePE(int comp, int platoon, int currentPERow, QVector<int> suitRowsPE)
{
    for(int i = 0; i < suitRowsPE.count(); i++)
        for(int row = suitRowsPE.at(i) * 6; row < suitRowsPE.at(i) * 6 + 6; row ++)
            if(canSwap(comp, platoon, currentPERow, row)){
                swapTableItems(comp, platoon, currentPERow, row);
                return true;
            }
    return false;
}

bool TableMixer::canSwapNoPE(int comp, int platoon, int row1, int row2)
{
    if(table[comp][platoon][row1][1] == "Нет преподавателя"
    || table[comp][platoon][row2][1] == "Нет преподавателя"
    || table[comp][platoon][row1][0] == "Физра"
    || table[comp][platoon][row2][0] == "Физра")
        return false;


    swap(table[comp][platoon][row1][0], table[comp][platoon][row2][0]);
    swap(table[comp][platoon][row1][1], table[comp][platoon][row2][1]);

    bool result = isCurrectRow(row1) && isCurrectRow(row2);



    swap(table[comp][platoon][row1][0], table[comp][platoon][row2][0]);
    swap(table[comp][platoon][row1][1], table[comp][platoon][row2][1]);

    return result;
}

bool TableMixer::isLineFree(int row, QString teacher, int currentComp, int currentPlatoon)
{
    for(int comp = 0; comp < companyCount; comp ++)
        for(int platoon = 0; platoon < 4; platoon ++)
            if(comp != currentComp && platoon != currentPlatoon && teacher == table[comp][platoon][row][1])
                return false;
    return true;
}

bool TableMixer::isTableCanBe()
{
    for(int row = 0; row < 36; row ++)
        if(!isCurrectRow(row))
            return false;
    return true;
}
