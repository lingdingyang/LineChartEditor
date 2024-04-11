#include "handler.h"

QList<double> Handler::getX1() const
{
    return x1;
}

void Handler::setX1(const QList<double> &newX1)
{
    x1 = newX1;
}

QList<double> Handler::getX2() const
{
    return x2;
}

void Handler::setX2(const QList<double> &newX2)
{
    x2 = newX2;
}

QList<double> Handler::getY1() const
{
    return y1;
}

void Handler::setY1(const QList<double> &newY1)
{
    y1 = newY1;
}

QList<double> Handler::getY2() const
{
    return y2;
}

void Handler::setY2(const QList<double> &newY2)
{
    y2 = newY2;
}

int Handler::getSelectedLine() const
{
    return selectedLine;
}

void Handler::setSelectedLine(int newSelectedLine)
{
    qDebug() << "setSelectedLine" << " " << newSelectedLine;
    selectedLine = newSelectedLine;
    emit inputUpdate();
}

int Handler::getSelectedPoint() const
{
    return selectedPoint;
}

void Handler::setSelectedPoint(int newSelectedPoint)
{
    qDebug() << "setSelectedPoint" << " " << newSelectedPoint;
    selectedPoint = newSelectedPoint;
    emit inputUpdate();
}

void Handler::updatePoint( double newX, double newY)
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

void Handler::removePoint()
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

void Handler::clear()
{
    x1.clear();
    y1.clear();
    x2.clear();
    y2.clear();
    selectedLine = -1;
    selectedPoint = -1;
    emit removeSelectedPoint();
}

Handler::Handler(QObject *parent)
    : QObject{parent}
{
}

void Handler::readCSV(QUrl url)
{
    qDebug() << url.path();
    QString path = url.path();
    path = path.right(path.length() - 1);
    qDebug() << path;
    QFile file(path);
    if(!file.exists()) {
        qDebug() << "不存在";
        return;
    }
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "打开失败";
        return;
    }
    QTextStream aStream(&file);
    aStream.setAutoDetectUnicode(true);
    QString str_x = aStream.readLine();
    QString str_y = aStream.readLine();
    QStringList list_x = str_x.split(',');
    QStringList list_y = str_y.split(',');
    clear();
    for(int i = 0; i < list_x.count(); i++) {
        x1.append(list_x[i].toDouble());
    }
    for(int i = 0; i < list_y.count(); i++) {
        y1.append(list_y[i].toDouble());
    }
    str_x = aStream.readLine();
    str_y = aStream.readLine();
    list_x = str_x.split(',');
    list_y = str_y.split(',');
    for(int i = 0; i < list_x.count(); i++) {
        x2.append(list_x[i].toDouble());
    }
    for(int i = 0; i < list_y.count(); i++) {
        y2.append(list_y[i].toDouble());
    }
    emit listUpdate();
}

void Handler::changeLine(double newX, double newY)
{
}
