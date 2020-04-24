import UIKit
public class Balls: UIView {
    //список цветов для шариков
    private var colors: [UIColor]
    //шарики
    private var balls: [UIView] = []
    //аниматор графических обьектов
    private var animator: UIDynamicAnimator?
    //обработик перемещений обьектов
    private var snapBehavior: UISnapBehavior?
    //обработчик столкновений
    private var collisionBehavior: UICollisionBehavior
    //инициализатор класса
    public init(colors: [UIColor]){
        self.colors = colors
        //создание значения свойства
        collisionBehavior = UICollisionBehavior(items: [])
        //границы отображения - обьекты взаимодействия
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundary( with:
            UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        backgroundColor = UIColor.gray
        //подключачаем аниматор с указанием на сам класс
        animator = UIDynamicAnimator(referenceView: self)
        //вызов функции отрисовки шариков
        ballsViev()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //размер шариков
    private var ballSize: CGSize = CGSize(width: 40, height: 40)
    func ballsViev () {
        //перебор переданных цветов
        for (index, color) in colors.enumerated() {
            //шарик это экземпляр класса UIView
            let ball = UIView(frame: CGRect.zero)
            //указываем цвет шарика
            ball.backgroundColor = color
            //наклвдываем отображение шарика на отображение подложки
            addSubview(ball)
            //добавляем эеземпляр шарика в массив шариков
            balls.append(ball)
            //вычисляем отступ шарика по осям Х и У
            let origin = 40*index + 100
            //отображение шарика в виде прямоугольника
            ball.frame = CGRect(x: origin, y: origin,
                                width: Int(ballSize.width), height: Int(ballSize.height))
            //с закругленными углами
            ball.layer.cornerRadius = ball.bounds.width / 2.0
            //добавим шарик в обработчик столкновений
            collisionBehavior.addItem(ball)
            
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location( in: self)
            for ball in balls {
                if (ball.frame.contains( touchLocation)) {
                    snapBehavior = UISnapBehavior( item: ball,snapTo: touchLocation)
                    snapBehavior?.damping = 0.5
                    animator?.addBehavior(snapBehavior!)
                }
            }
        }
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self )
            if let snapBehavior = snapBehavior {
                snapBehavior.snapPoint = touchLocation
            }
        }
    }
     override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior {
            animator?.removeBehavior(snapBehavior)
        }
        snapBehavior = nil
    }
}
