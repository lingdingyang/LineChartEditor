#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include<QDebug>
#include<QUrl>
#include<QFile>
class Controller : public QObject
{
    Q_OBJECT
private:
    // 保存两条线的数据
    QList<double> x1;
    QList<double> x2;
    QList<double> y1;
    QList<double> y2;
    // 指定选中的线以及选中的点
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
    bool checkFile(const QString& path);
public:

    explicit Controller(QObject *parent = nullptr);
    // getter setter
    // setSelectedPoint和setSelectedLine方法会发送信号通知qml选择点改变来修改高亮显示
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
    // 处理读取文件
    void readCSV(const QUrl& url);
    // 处理修改点的坐标
    void updatePoint(const double newX, const double newY);
    // 处理删除某点
    void removePoint();

signals:
    // 更新折线图的信号
    void listUpdate();
    // 更新输入框的信号
    void inputUpdate();
    // 删除选中点高亮的信号
    void removeSelectedPoint();
    void showDialog(QString msg);
};

#endif // CONTROLLER_H
