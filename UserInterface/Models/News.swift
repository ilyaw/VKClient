//
//  News.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import Foundation


//УДАЛИИТЬ ПОТОМ
struct News {
    let postAvatar: String
    let postAuthor: String
    let postDate: String
    let postContentText: String //текст
    let postImage: String
    var likeCount: Int
    var commentCount: Int
    var shareCount: Int
    let viewsCount: Int
}

func getAllNews() -> [News] {
    return [News.init(postAvatar: "post_1", postAuthor: "Wylsacom", postDate: "11 мар в 16:08", postContentText: "HomePod mini стал хитом с момента своего дебюта прошлой осенью, предлагая клиентам потрясающий звук, интеллектуального помощника и управление «умным» домом всего за 99 долларов. Мы сосредоточили наши усилия на HomePod mini.", postImage: "homepod", likeCount: 10, commentCount: 2, shareCount: 3, viewsCount: 56),
            News.init(postAvatar: "post_2", postAuthor: "CMT - Научный подход", postDate: "2 мар в 16:24", postContentText: """
 Чтo кacaeтcя гpуппы кpoви и диeты / cтиля питaния — тут никaкoй cвязи учeныe нe нaxoдят.
 Идeя o тoм, чтo гpуппa кpoви влияeт нa cпocoбнocть opгaнизмa пepeвapивaть paзныe виды пищи, cпpaвлятьcя co cтpeccoм и peaгиpoвaть нa физичecкую aктивнocть, пpишлa в гoлoву aмepикaнcкoму нaтуpoпaту Питepу Д’Aдaмo. И oн cмoг нa нeй нeплoxo зapaбoтaть.⠀

 Oн пpидумaл диeты для кaждoй гpуппы кpoви и издaл нa эту тeму книгу, кoтopaя в cвoё вpeмя cтaлa бecтceллepoм, и у этoгo cпocoбa питaния дo cиx пop нeмaлo пocлeдoвaтeлeй пo вceму миpу.⠀

 Ha 2013 гoд выxoдил cиcтeмaтичecкий oбзop иccлeдoвaний o диeтax пo гpуппe кpoви «Blood type diets lack supporting evidence: a systematic review», гдe былo пpoaнaлизиpoвaнo 1415 иccлeдoвaний этoгo peжимa питaния. Былo дaжe бoльшoe иccлeдoвaниe c 1455 учacтникaми. B цeлoм учeныe нe oбнapужили кaкoй-либo пoльзы в питaнии, cвязaннoй c гpуппoй кpoви.
 """, postImage: "dieta", likeCount: 34, commentCount: 12, shareCount: 4, viewsCount: 156),
            News.init(postAvatar: "post_3", postAuthor: "The Brown Room", postDate: "вчера в 20:13", postContentText: "«ВКонтакте» подвела итоги ежегодной премии VK Mini Apps. Всего поступило около 200 заявок от сторонних разработчиков в трёх категориях: «Лучшее мини-приложение», «Лучший чат-бот» и «Лучшая игра». Победители всех групп получат денежное вознаграждение в размере 300 000, 200 000 и 100 000 рублей за первые три места соответственно.", postImage: "vkoffice", likeCount: 6, commentCount: 2, shareCount: 3, viewsCount: 29),
            News.init(postAvatar: "post_4", postAuthor: "Apple", postDate: "11 мар в 18:20", postContentText: "Организаторы исследования Apple Hearing Study публикуют новые данные, полученные от тысяч участников из США, чтобы помочь людям больше узнать о здоровье слуха.", postImage: "health", likeCount: 345, commentCount: 23, shareCount: 3, viewsCount: 3210),
            News.init(postAvatar: "post_5", postAuthor: "Типичный гитарист", postDate: "10 мар в 0:23", postContentText: "Fender Srakokaster USSR 1989 Vintage Limited Edition в винтажном состоянии! Подходит практически для любых жанров музыки - дворовой джаз, крунк, блатняк, песни Цоя, Сектор Газа и многие другие.", postImage: "guitar", likeCount: 3, commentCount: 2, shareCount: 3, viewsCount: 10)]

}
