﻿
&НаСервере
Функция  Команда1НаСервере()
	ЗапросПОльзователь = Новый Запрос;
	ЗапросПОльзователь.Текст =   "ВЫБРАТЬ
	                             |	Пользователь.Ссылка КАК Ссылка,
	                             |	ВЫБОР
	                             |		КОГДА Пользователь.ЮрФизЛицо = ЗНАЧЕНИЕ(перечисление.ЮрФизЛицо.ФизЛицо)
	                             |			ТОГДА ""ФизЛицо""
	                             |		ИНАЧЕ ""ЮрЛицо""
	                             |	КОНЕЦ КАК ЮрФизЛицо
	                             |ИЗ
	                             |	Справочник.Пользователь КАК Пользователь
	                             |ГДЕ
	                             |	Пользователь.Логин = &Логин" ;
	ЗапросПОльзователь.УстановитьПараметр("Логин",Строка(Login)); 
	
	ВЫборка = ЗапросПОльзователь.Выполнить().Выбрать();
	
	ПОльзователь = Справочники.Пользователь.ПустаяСсылка();
	Пока ВЫборка.Следующий() Цикл 
		ПОльзователь = ВЫборка.Ссылка;
	КонецЦикла;

	//ЗаписьЖурналаРегистрации("ПОльзователь",,,ПОльзователь);
	
	
	
	
	//Guid = Запрос.ПараметрыURL.Получить("Guid");
	УИД = Новый УникальныйИдентификатор(Guid);
		//ЗаписьЖурналаРегистрации("Guid",,,Guid);

	СсылкаНаИнициативу = Справочники.Инициатива.ПолучитьСсылку(УИД);
		//ЗаписьЖурналаРегистрации("СсылкаНаИнициативу",,,СсылкаНаИнициативу);
	ЗапросИнициатива = Новый Запрос;
	ЗапросИнициатива.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                         |	Инициатива.Ссылка КАК Ссылка,
	                         |	Инициатива.Наименование КАК Наименование,
	                         |	Инициатива.Содержание КАК Содержание,
	                         |	Инициатива.СрокДо КАК СрокДо,
	                         |	Инициатива.ДоступностьЮрЛицам КАК ДоступностьЮрЛицам,
	                         |	Инициатива.ДоступностьФизЛицам КАК ДоступностьФизЛицам
	                         |ПОМЕСТИТЬ ВТ
	                         |ИЗ
	                         |	Справочник.Инициатива КАК Инициатива
	                         |;
	                         |
	                         |////////////////////////////////////////////////////////////////////////////////
	                         |ВЫБРАТЬ
	                         |	СУММА(ЕСТЬNULL(РейтингИнициатив.ОценкаЛайк, 0)) КАК ОценкаЛайк,
	                         |	СУММА(ЕСТЬNULL(РейтингИнициатив.ОценкаДизЛайк, 0)) КАК ОценкаДизЛайк,
	                         |	РейтингИнициатив.Инициатива КАК Инициатива
	                         |ПОМЕСТИТЬ ВТ_рейтинг
	                         |ИЗ
	                         |	РегистрСведений.РейтингИнициатив КАК РейтингИнициатив
	                         |
	                         |СГРУППИРОВАТЬ ПО
	                         |	РейтингИнициатив.Инициатива
	                         |;
	                         |
	                         |////////////////////////////////////////////////////////////////////////////////
	                         |ВЫБРАТЬ
	                         |	ВТ.Ссылка КАК Ссылка,
	                         |	ВТ.Наименование КАК Наименование,
	                         |	ВТ.Содержание КАК Содержание,
	                         |	ВТ.СрокДо КАК СрокДо,
	                         |	ВТ.ДоступностьЮрЛицам КАК ДоступностьЮрЛицам,
	                         |	ВТ.ДоступностьФизЛицам КАК ДоступностьФизЛицам,
	                         |	ЕСТЬNULL(ВТ_рейтинг.ОценкаЛайк, 0) КАК ОценкаЛайк,
	                         |	ЕСТЬNULL(ВТ_рейтинг.ОценкаДизЛайк, 0) КАК ОценкаДизЛайк
	                         |ИЗ
	                         |	ВТ КАК ВТ
	                         |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_рейтинг КАК ВТ_рейтинг
	                         |		ПО ВТ.Ссылка = ВТ_рейтинг.Инициатива
	                         |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтветыНаВопросы КАК ОтветыНаВопросы
	                         |		ПО ВТ.Ссылка = ОтветыНаВопросы.Инициатива
	                         |ГДЕ
	                         |	ВТ.Ссылка = &Ссылка";
	ЗапросИнициатива.УстановитьПараметр("Ссылка",СсылкаНаИнициативу );
	//ЗапросИнициатива.УстановитьПараметр("ПОльзователь",ПОльзователь );
	
	
	Результат = Новый Структура("КодОтвета, Сообщение, СообщениеОбОшибке");
	ИмяФайлаВыгрузки = КаталогВременныхФайлов() + "\123.json";     
	
	РезЗапроса = ЗапросИнициатива.Выполнить();
	
	ВыборкаПоИнициативе = РезЗапроса.Выбрать();
	
	
	Инициатива = Новый Структура;
	
	Пока ВыборкаПоИнициативе.Следующий() Цикл 
		Инициатива.Вставить("Наименование",ВыборкаПоИнициативе.Наименование);
		Инициатива.Вставить("ОценкаЛайк",ВыборкаПоИнициативе.ОценкаЛайк);
		Инициатива.Вставить("ОценкаДизЛайк",ВыборкаПоИнициативе.ОценкаДизЛайк);
		Инициатива.Вставить("ДоступностьЮрЛицам",ВыборкаПоИнициативе.ДоступностьЮрЛицам);
		Инициатива.Вставить("ДоступностьФизЛицам",ВыборкаПоИнициативе.ДоступностьФизЛицам);
		Инициатива.Вставить("ГУИД",Строка(ВыборкаПоИнициативе.Ссылка.УникальныйИдентификатор()));
		Инициатива.Вставить("Содержание",ВыборкаПоИнициативе.Содержание);
		Инициатива.Вставить("СрокДо",Формат(ВыборкаПоИнициативе.СрокДо,"ДФ=dd.MM.yyyy"));
		Результат.Вставить("КодОтвета", Истина);
		Результат.Вставить("СообщениеОбОшибке", "");
		 ЗаписьЖурналаРегистрации("Guid",,,Guid);


	КонецЦикла;
	

	
	
	
	
	
	ЗапросОтзывы = Новый Запрос;
	ЗапросОтзывы.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                     |	Инициатива.Ссылка КАК Ссылка,
	                     |	Инициатива.Наименование КАК Наименование,
	                     |	Инициатива.Содержание КАК Содержание,
	                     |	Инициатива.СрокДо КАК СрокДо,
	                     |	Инициатива.ДоступностьЮрЛицам КАК ДоступностьЮрЛицам,
	                     |	Инициатива.ДоступностьФизЛицам КАК ДоступностьФизЛицам
	                     |ПОМЕСТИТЬ ВТ
	                     |ИЗ
	                     |	Справочник.Инициатива КАК Инициатива
	                     |;
	                     |
	                     |////////////////////////////////////////////////////////////////////////////////
	                     |ВЫБРАТЬ
	                     |	ВТ.Ссылка КАК Ссылка,
	                     |	ОпросВопросы.Вопрос КАК Вопрос,
	                     |	ОпросВопросы.Вопрос.ТипВопроса КАК ТипВопроса
	                     |ИЗ
	                     |	ВТ КАК ВТ
	                     |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос КАК Опрос
	                     |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос.Вопросы КАК ОпросВопросы
	                     |			ПО Опрос.Ссылка = ОпросВопросы.Ссылка
	                     |		ПО ВТ.Ссылка = Опрос.Инициатива
	                     |ГДЕ
	                     |	ВТ.Ссылка = &Ссылка";
	ЗапросОтзывы.УстановитьПараметр("Ссылка",СсылкаНаИнициативу );
	//ЗапросОтзывы.УстановитьПараметр("ПОльзователь",ПОльзователь );
	
	Если НЕ ЗапросОтзывы.Выполнить().Пустой()  Тогда 
		Инициатива.Вставить("ПользовательПрошелОпрос",Ложь);
		
		ВыборкаОтзывы = ЗапросОтзывы.Выполнить().Выбрать();
		МассивВопросов = Новый Массив;
		МассивОтветов = Новый Массив;
		
		Пока ВыборкаОтзывы.Следующий() Цикл 
			ВопросОтветы = Новый Структура;
			//ВопросОтветы.Вставить("Инициатива", Строка(ВыборкаОтзывы.Ссылка.УникальныйИдентификатор()));
			ВопросОтветы.Вставить("ТипВопроса", СТрока(ВыборкаОтзывы.ТипВопроса));
			ВопросОтветы.Вставить("Вопрос", СТрока(ВыборкаОтзывы.Вопрос));
			ВопросОтветы.Вставить("КодВопроса", СТрока(ВыборкаОтзывы.Вопрос.Код));
			МассивВопросов.Добавить(ВопросОтветы);
			
			Для Каждого Стр Из ВыборкаОтзывы.Вопрос.Ответы Цикл 
				СтруктураОтветы = Новый Структура;
				СтруктураОтветы.Вставить("КодОтвета", СТрока(Стр.Ответ.Код));
				СтруктураОтветы.Вставить("Ответ", СТрока(Стр.Ответ));
				МассивОтветов.Добавить(СтруктураОтветы);
			КонецЦикла;
			МассивВопросов.Добавить(МассивОтветов);
			
			
		КонецЦикла;
		Инициатива.Вставить("МассивВопросов",МассивВопросов);
		
			
	КонецЕсли;

	
	ЗаписьJSON = Новый ЗаписьJSON; 
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(); 
	ЗаписьJSON.ОткрытьФайл(ИмяФайлаВыгрузки, , , ПараметрыЗаписи) ; 
	ЗаписатьJSON(ЗаписьJSON, Инициатива); 
	ЗаписьJSON.Закрыть();
	
	ТекстДок = Новый ТекстовыйДокумент();
	ТекстДок.Прочитать(ИмяФайлаВыгрузки,КодировкаТекста.UTF8);
	
	
	Результат.Вставить("Сообщение", ТекстДок.ПолучитьТекст());
	
	
	

	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура Команда1(Команда)
	Команда1НаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Login =  "ivanova";
	Guid = "0db9323a-e181-11e9-b200-b4b6860c0a9d";
КонецПроцедуры
