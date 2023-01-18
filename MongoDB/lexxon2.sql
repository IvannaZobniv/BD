db.teacher.find()
db.students.find()
-- агрегатна функція- групування( спочатку вказуємо id, а потім поле по якому групуємо,
-- обов'язково прописуємо як стрінгу).Після групування його id буде те по чому групував.
db.teacher.aggregate([
    {
        $group: {
            _id: '$lesson'
        }
    }
])
-- рахуємо кількість цих уроків-countOfTeachers.Після групування назва полів з ліва може бути
-- довільною. Також рахуємо min та max зарплату, середню суму зп (avg), підрахувати повністю суму всіх вчителів
-- які викладають один і той самий предмет.
db.teacher.aggregate([
    {
        $group: {
            _id: '$lesson',
            countOfTeachers: { $sum: 1 },
            min: { $min: '$payment' },
            max: { $max: '$payment' },
            avg: { $avg: '$payment' },
            sumMoney: { $sum: '$payment' }
        }
    }
])
-- функція match, схожа на find- щось шукає постійно. В match ми прописуємо об'єкт пошуку
-- (який саме нам потрібен).Правильніше такі функції ставити перед, обробкою своїх даних.
db.teacher.aggregate([
    {
        $match: { lesson: 'basic' }
    },
    {
        $group: {
            _id: '$lesson',
            countOfTeachers: { $sum: 1 },
            min: { $min: '$payment' },
            max: { $max: '$payment' },
            avg: { $avg: '$payment' },
            sumMoney: { $sum: '$payment' }
        }
    }
])
-- sort-ми хочемо сортувати по сумі грошей від найбільшої до найменшої. project- виконують в самому
-- кінці агрегатних функцій (фінальний показ того об'єтка що ми хочемо бачити)
db.teacher.aggregate([
    {
        $group: {
            _id: '$lesson',
            countOfTeachers: { $sum: 1 },
            min: { $min: '$payment' },
            max: { $max: '$payment' },
            avg: { $avg: '$payment' },
            sumMoney: { $sum: '$payment' }
        }
    },
    { $sort: { sumMoney: -1 } },
    {
        $project: {
            lesson: '$_id',
            countOfTeachers: 1,
            min: 1,
            max: 1,
            avg: 1,
            sumMoney: 1,
            _id: 0

        }
    }
])
db.teacher.find()
-- як скріплюється колекція з колекцією - lookup (це об'єкт).from - з якою колекцією будемо це все скріплювати,
-- localField - наша локальна філда,foreignField - що буде foreign key для студентів, as - назва яка буде
-- виводитись в нашому teacher. В агрегатних функціях порядок має значення, спочатку skip потім беремо limit.
db.teacher.aggregate([
    {
        $lookup: {
            from: 'students',
            localField: 'class_curator',
            foreignField: 'class',
            as: 'myStudents'
        }
    },
    { $skip: 4 },
    { $limit: 2 }
])
-- Хочемо знайти всіх вчителів в яких поле class_curator буде >= 5.сортуємо від більшого до меншого. Об'єднуємо
-- зі студентами. І ще раз шукаємо тих вчителів в котрих хочаб у одного з студентів один з батьків доктор
db.teacher.aggregate([
    {
        $match: {
            class_curator: { $gte: 5 }
        }
    },
    { $sort: { class_curator: -1 } },
    {
        $lookup: {
            from: 'students',
            localField: 'class_curator',
            foreignField: 'class',
            as: 'myStudents'
        }
    },
    {
        $match: {
            'myStudents.parents.profession': 'doctor'
        }
    }
])
--Звертаємось до наших студентів, рахуємо кількість батьків які є докторами в кожного студента.
--Через match - звертаємось прямо до наших студентів(шукаємо всіх учнів в яких один з батьків доктор)
--unwind - розбиває масив на складові (кількість елементів що є в масиві). Розбили одного студента(id одне)
-- на двох батька і матір з різними професіями. І знову через match - шукаємо саме докторів. І рахуємо
-- їх(рахує кількість об'єктів)
db.students.aggregate([
    {
        $match: {
            'parents.profession': 'doctor'
        }
    },
    {
        $unwind: '$parents'
    },
    {
        $match: {
            'parents.profession': 'doctor'
        }
    },
    { $count: 'DoctorCount' }
])