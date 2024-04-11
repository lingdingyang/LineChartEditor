#include "controller.h"

QList<double> Controller::getX1() const
{
    return x1;
}

void Controller::setX1(const QList<double> &newX1)
{
    x1 = newX1;
}

QList<double> Controller::getX2() const
{
    return x2;
}

void Controller::setX2(const QList<double> &newX2)
{
    x2 = newX2;
}

QList<double> Controller::getY1() const
{
    return y1;
}

void Controller::setY1(const QList<double> &newY1)
{
    y1 = newY1;
}

QList<double> Controller::getY2() const
{
    return y2;
}

void Controller::setY2(const QList<double> &newY2)
{
    y2 = newY2;
}

int Controller::getSelectedLine() const
{
    return selectedLine;
}

void Controller::setSelectedLine(int newSelectedLine)
{
    qDebug() << "setSelectedLine" << " " << newSelectedLine;
    selectedLine = newSelectedLine;
    emit inputUpdate();
}

int Controller::getSelectedPoint() const
{
    return selectedPoint;
}

void Controller::setSelectedPoint(int newSelectedPoint)
{
    qDebug() << "setSelectedPoint" << " " << newSelectedPoint;
    selectedPoint = newSelectedPoint;
    emit inputUpdate();
}



void Controller::updatePoint(const double newX, const double newY)
{
    qDebug() << "updatePoint";
    qDebug() << newX << " " << newY;
    if(selectedPoint == -1 || selectedLine == -1) {
        return;
    }
    if(selectedLine == 1) {
        x1[selectedPoint] = newX;
        y1[selectedPoint] = newY;
    } else {
        x2[selectedPoint] = newX;
        y2[selectedPoint] = newY;
    }
    emit listUpdate();
}

void Controller::removePoint()
{
    if(selectedPoint == -1 || selectedLine == -1) {
        return;
    }
    if(selectedLine == 1) {
        x1.removeAt(selectedPoint);
        y1.removeAt(selectedPoint);
    } else {
        x2.removeAt(selectedPoint);
        y2.removeAt(selectedPoint);
    }
    emit listUpdate();
}

void Controller::clear()
{
    x1.clear();
    y1.clear();
    x2.clear();
    y2.clear();
    selectedLine = -1;
    selectedPoint = -1;
    emit removeSelectedPoint();
}

bool Controller::checkFile(const QString &path)
{
    QFile file(path);
    if(!file.exists()) {
        qDebug() << "不存在";
        return false;
    }
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "打开失败";
        return false;
    }
    int cnt = 0;
    QTextStream in(&file);
    while (!in.atEnd()) {
        in.readLine();
        cnt++;
    }
    file.close();
    if(cnt != 4) {
        qDebug() << "文件行数错误";
        return false;
    }
    return true;
}

Controller::Controller(QObject *parent)
    : QObject{parent}
{
}

void Controller::readCSV(const QUrl& url)
{
    qDebug() << url.path();
    QString path = url.path();
    path = path.right(path.length() - 1);
    qDebug() << path;
    if(!checkFile(path)) {
        return;
    }
    QFile file(path);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "打开失败";
        return ;
    }
    QTextStream aStream(&file);
    aStream.setAutoDetectUnicode(true);
    QString str_x1 = aStream.readLine();
    QString str_y1 = aStream.readLine();
    QStringList list_x1 = str_x1.split(',');
    QStringList list_y1 = str_y1.split(',');
    QString str_x2 = aStream.readLine();
    QString str_y2 = aStream.readLine();
    QStringList list_x2 = str_x2.split(',');
    QStringList list_y2 = str_y2.split(',');
    if(list_x1.count() != list_y1.count()) {
        qDebug() << "文件第一条线数据错误";
        file.close();
        return;
    }
    if(list_x2.count() != list_y2.count()) {
        qDebug() << "文件第二条线数据错误";
        file.close();
        return;
    }
    clear();
    for(int i = 0; i < list_x1.count(); i++) {
        x1.append(list_x1[i].toDouble());
    }
    for(int i = 0; i < list_y1.count(); i++) {
        y1.append(list_y1[i].toDouble());
    }
    for(int i = 0; i < list_x2.count(); i++) {
        x2.append(list_x2[i].toDouble());
    }
    for(int i = 0; i < list_y2.count(); i++) {
        y2.append(list_y2[i].toDouble());
    }
    file.close();
    emit listUpdate();
}

