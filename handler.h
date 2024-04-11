#ifndef HANDLER_H
#define HANDLER_H

#include <QObject>
#include<QDebug>
#include<QUrl>
#include<QFile>
class Handler : public QObject
{
    Q_OBJECT
private:
    QList<double> x1;
    QList<double> x2;
    QList<double> y1;
    QList<double> y2;
    int selectedLine = -1;
    int selectedPoint = -1;
    Q_PROPERTY(QList<double> x1 READ getX1() WRITE setX1() FINAL CONSTANT)
    Q_PROPERTY(QList<double> x2 READ getX2() WRITE setX2() FINAL CONSTANT)
    Q_PROPERTY(QList<double> y1 READ getY1() WRITE setY1() FINAL CONSTANT)
    Q_PROPERTY(QList<double> y2 READ getY2() WRITE setY2() FINAL CONSTANT)
    Q_PROPERTY(int selectedLine READ getSelectedLine() WRITE setSelectedLine() FINAL CONSTANT)
    Q_PROPERTY(int selectedPoint READ getSelectedPoint() WRITE setSelectedPoint() FINAL CONSTANT)

private:
    void clear();
public:

    explicit Handler(QObject *parent = nullptr);
    QList<double> getX1() const;
    void setX1(const QList<double> &newX1);
    QList<double> getX2() const;
    void setX2(const QList<double> &newX2);
    QList<double> getY1() const;
    void setY1(const QList<double> &newY1);
    QList<double> getY2() const;
    void setY2(const QList<double> &newY2);
    int getSelectedLine() const;
    void setSelectedLine(int newSelectedLine);
    int getSelectedPoint() const;
    void setSelectedPoint(int newSelectedPoint);

public slots:
    void readCSV(QUrl url);
    void changeLine(double newX, double newY);
    void updatePoint(double newX, double newY);
    void removePoint();

signals:
    void listUpdate();
    void inputUpdate();
    void removeSelectedPoint();
};

#endif // HANDLER_H
