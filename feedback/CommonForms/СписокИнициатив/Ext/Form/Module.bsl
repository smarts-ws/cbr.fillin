﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ЗаполнениеТест();
	
	ПолучитьСписокИнициатив();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеТест()
	
	стр = СписокИнициатив.Добавить();
	стр.Инициатива = "Инициатива 1";
	стр.Лайки = "+12";
	стр.Дизлайки = "-1";
	
	стр = СписокИнициатив.Добавить();
	стр.Инициатива = "Инициатива 2";
	стр.Лайки = "+1";
	стр.Дизлайки = "-15";
	
	стр = СписокИнициатив.Добавить();
	стр.Инициатива = "Инициатива 3";
	стр.Лайки = "+5";
	стр.Дизлайки = "-5";



	
КонецПроцедуры

&НаКлиенте
Процедура СписокИнициативВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("Инициатива", СписокИнициатив[ВыбраннаяСтрока].Инициатива);
	//ПараметрыФормы.Вставить("Лайки", СписокИнициатив[ВыбраннаяСтрока].Лайки);
	//ПараметрыФормы.Вставить("Дизлайки", СписокИнициатив[ВыбраннаяСтрока].Дизлайки);
	ПараметрыФормы.Вставить("ГУИД", СписокИнициатив[ВыбраннаяСтрока].ГУИД);

	//Оповещение = Новый ОписаниеОповещения("ФормаИнициативыЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ФормаИнициативы", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ФормаИнициативыЗавершение (РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокИнициатив()
	
	Логин = Константы.Логин.Получить();
	СерверИсточник = "mysony";
	Адрес = "/backend/hs/v1/spisok/"+ Логин;
	
	
	//ПараметрыЗапроса = Новый Структура;
	//ПараметрыЗапроса.Вставить("fizik", Истина);
	//ПараметрыЗапроса = "?user=" + Строка(Пользователь.УникальныйИдентификатор());
	
	Адрес = Адрес; //+ ПараметрыЗапроса;
	HTTPЗапрос = Новый HTTPЗапрос(Адрес);
		
	HTTP = Новый HTTPСоединение(СерверИсточник);
	HTTPОтвет = HTTP.Получить(HTTPЗапрос);
	
	Если HTTPОтвет.КодСостояния = 200 Тогда
		СтрокаОтвета = HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Чтение		 =	Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(СтрокаОтвета);
	Джисон = ПрочитатьJSON(Чтение,Истина);
	Если ТипЗнч(Джисон) = Тип("Соответствие") Тогда
		Если Не Джисон["Ошибка"] = Неопределено Тогда
			Элементы.НетИнициатив.Видимость = Истина;
			Элементы.СписокИнициатив.Видимость = Ложь;
		КонецЕсли;		
	Иначе
		//СписокИнициатив.Очистить();
		Для Каждого стр Из Джисон Цикл
			стрТЗ = СписокИнициатив.Добавить();
			стрТЗ.Инициатива = стр["Наименование"];
			стрТЗ.Лайки = стр["ОценкаЛайк"];
			стрТЗ.Дизлайки = стр["ОценкаДизлайк"];
			стрТЗ.СрокДо = стр["СрокДо"];
			стрТЗ.ГУИД = стр["ГУИД"];
		КонецЦикла;
		Элементы.НетИнициатив.Видимость = Ложь;
		Элементы.СписокИнициатив.Видимость = Истина;
	КонецЕсли;
				

	
КонецПроцедуры