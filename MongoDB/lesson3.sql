db.students.find()
--пошук студентів всі хто вивчають математику
db.students.find({lessons: 'mathematics'})
-- пошук по декількох полях всі хто вивчають і мат. і агллійську, спеціальний оператор
-- all- шукає співпадіння( і перше і друге шукає)
db.students.find({lessons: {$all: ['english', 'mathematics']}})
--lessons.1-шукаємо по розташуванню об'єкта в масиві, тобто 2 елементом повинен бути mathematics
db.students.find({'lessons.1': 'mathematics'})
--шукаємо повністю всіх {}, студентів у яких, але хочемо бачити тільки 2 першиш ({$slice: 2})
db.students.find({}, {lessons: {$slice: 2}})
-- шукаємо по розміру масива, тобто в ньому є тільки 2 елемента. В size-можемо вставляти тільки цифру
db.students.find({lessons: {$size: 2}})
--findOne-шукаємо саме одного (першого) студента в якого другим елементом масиву є mathematics і виведе
--його ім'я (.name)
db.students.findOne({'lessons.1': 'mathematics'}).name
--перегляд об'єкта
db.students.find({_id: ObjectId('63b7be3219932758481a9bf0')})
--додавання щось в масив-push
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$push: {lessons: 'js'}}
    )
-- методом updateOne ми не можемо додати два окремі елементи в масив як окремі, тому що він запакує його
-- як один елемент у вигляді масиву з двома елементами
 db.students.updateOne(
     {_id:ObjectId('63b7be3219932758481a9bf0')},
     {$push:{lessons:['python', 'java']}}
     )
-- щоб видалити останній доданий елемент з масиву, використовуємо pop (1-видалення останнього елементу,
-- -1-видалення першого елементу)
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$pop: {lessons: 1}}
    )
-- each- щоб додати декілька елементів в масив одночасно
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$push: {lessons: {$each: ['python', 'java']}}}
    )
-- pull-видалення елементу по значенню
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$pull: {lessons: 'mathematics'}}
    )
--unset-видалення по індексу елементу масиву
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$unset: {'lessons.1': 1}}
    )
-- видалення останнього елементу
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$unset: {'lessons':1}}
    )
-- видалення всіх змінних - null
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$pull: {lessons: null}}
    )
-- addToSet-додавання без дублікатів. Буде перевіряти чи є уже схожий елемент в масиві і якщо є то його
-- не додасть в масив
db.students.updateOne(
    {_id: ObjectId('63b7be3219932758481a9bf0')},
    {$addToSet: {lessons: 'mysql'}}
    )
--розв'язок задачі з *** Не працюючих батьків влаштувати офіціантами (підказка: гуглимо "arrayFilters")
db.students.find({_id: ObjectId('63b7be3219932758481a9bf0')})
db.students.find()
db.students.updateMany(
    {parents: {$exists: 1}, 'parents.profession': null},
    {$set: {'parents.$[item].profession': 'waiter'}},
    {'arrayFilters': [{'item.profession': null}]}
    )
-- або такий розв'язок
db.students.updateMany(
    {'parents': {$exists: 1}},
    {$set: {"parents.$[elem].profession": 'waiter'}},
    {arrayFilters: [{"elem.profession": {$exists: 0}}]})
-- як знайти ось такий варіант
 db.students.find({lessons:{$size:{$gte:3}}})
-- вказаний варіант вище можна виконати за допомогою агрегатної функції (aggregate), addFields - додає нове
-- поле, в якому порахуємо довжину поля-size.
 db.students.aggregate([
     {
         $addFields:{
             lessonsCount:{$size:'$lessons'}
         }
     }
 ])
--1)lessonsCount.після цього використовуємо спеціальний оператор (cond)-задає умову, передаємо йому
-- ключ через if, те що ми будемо перевіряти (isArray)- нас цікавить саме масив під полем lessons,
-- другий елемент в cond це (then)-прописуємо що ми хочемо виконати, тобто знайти розмір масиву
-- (size), і якщо умова не справдиться задаємо умову (else) запиши 0.Таким чином нам не видастся
-- помилка при виконанні.
-- 2)sumClassAndLessonsCount- хочемо ще одне поле яке буде додавати lessonsCount + class.Виконуємо
-- за допомогою add.Але у нас нічого не виконається, тому що кожна агрегатка передає в наступну те
-- що вона виконала. Тому нам потрібно додати поле через addFields.
-- 3) шукаємо тих lessons в яких кількість занять >= 3. за допомогою match.
db.students.aggregate([
    {
        $addFields:{
            lessonsCount:{$cond:{if:{$isArray:'$lessons'}, then:{$size:'$lessons'}, else:0}},

        }
    },
    {
        $addFields:{
            sumClassAndLessonsCount:{$add:['$lessonsCount', '$class']}
        }
    },
    {
        $match:{
            lessonsCount:{$gte:3}
        }
    }
])
-- за допомогою project - відключаємо поле lessonsCount, тому що при фінальному виводі
-- не хочемо його виводити
db.students.aggregate([
    {
        $addFields:{
            lessonsCount:{$cond:{if:{$isArray:'$lessons'}, then:{$size:'$lessons'}, else:0}},

        }
    },
    {
        $match:{
            lessonsCount:{$gte:3}
        }
    },
    {
        $project:{

            lessonsCount:0
        }
    }
])
--17) Знайти найуспішніший клас-групуємо по класам (group) і знаходимо середнє значення (avg),
--потім сортуємо, від більшого до меншого (sort), -1, та ставимо ліміт.І в project виводимо
-- class, avgByClass, а id - виключаємо.
db.students.aggregate([
    {
        $group:{
            _id:'$class',
            avgByClass:{$avg:'$avgScore'}
        }
    },
    {$sort:{avgByClass:-1}},
    {$limit:1},
    {
        $project:{
            class:'$_id',
            _id:0,
            avgByClass:1
        }
    },
    -- {
    --     // якщо потім ще потрібно включати якісь поля, тоді ми вказуємо йому що бери за базу
    --     // те що було на початку (document) ROOT - це головний документ.
    --     $project:{
    --         'document':"$$ROOT",
    --
    --     }
    -- },
    -- {   // реплейснимо рутовий запис документу (replaceRoot) в якості нового документа ми
    --     // запишемо якраз наш початковий документ.
    --     '$replaceRoot':{'newRoot':'$document'}
    -- }
])
