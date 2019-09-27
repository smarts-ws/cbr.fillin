﻿Функция  СформироватьСписокИнициатив(Параметры)  Экспорт 

	
	Результат = Новый Структура("КодОтвета, Сообщение, СообщениеОбОшибке");
	ИмяФайлаВыгрузки = КаталогВременныхФайлов() + "\123.json";     
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	Инициатива.Ссылка КАК Ссылка,
	               |	Инициатива.Наименование КАК Наименование,
	               |	Инициатива.Содержание КАК Содержание,
	               |	Инициатива.СрокДо КАК СрокДо,
	               |	Инициатива.ДоступностьЮрЛицам КАК ДоступностьЮрЛицам,
	               |	Инициатива.ДоступностьФизЛицам КАК ДоступностьФизЛицам
	               |ПОМЕСТИТЬ ВТ
	               |ИЗ
	               |	Справочник.Инициатива КАК Инициатива
	               |ГДЕ
	               |	Инициатива.СрокДо >= &ТекущаяДата
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
	               |	РейтингИнициатив.ОценкаЛайк КАК ОценкаЛайк,
	               |	РейтингИнициатив.ОценкаДизЛайк КАК ОценкаДизЛайк
	               |ИЗ
	               |	ВТ КАК ВТ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РейтингИнициатив КАК РейтингИнициатив
	               |		ПО ВТ.Ссылка = РейтингИнициатив.Инициатива
	               |ГДЕ
	               |	(ВТ.ДоступностьФизЛицам = &ДоступностьФизЛицам
	               |			ИЛИ ВТ.ДоступностьЮрЛицам = ВТ.ДоступностьФизЛицам)";	
	
	
	Запрос.УстановитьПараметр("ДоступностьФизЛицам",Параметры.ФизЮрЛицо);
	Запрос.УстановитьПараметр("ТекущаяДата",ТекущаяДата());
 	
	
	
	РезЗапроса = Запрос.Выполнить();
	Если РезЗапроса.Пустой() Тогда 

		
		
		Инициатива = Новый Структура;
		Инициатива.Вставить("Ошибка", "Не найдено инициатив");
		
		ЗаписьJSON = Новый ЗаписьJSON; 
		ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(); 
		ЗаписьJSON.ОткрытьФайл(ИмяФайлаВыгрузки, , , ПараметрыЗаписи) ; 
		ЗаписатьJSON(ЗаписьJSON, Инициатива); 
		ЗаписьJSON.Закрыть();
		
		ТекстДок = Новый ТекстовыйДокумент();
		ТекстДок.Прочитать(ИмяФайлаВыгрузки,КодировкаТекста.UTF8);
		
		
		Результат.Вставить("Сообщение", ТекстДок.ПолучитьТекст());

		Возврат Результат;
	КонецЕсли;
	
	
	Выборка = РезЗапроса.Выбрать();
	
	Инициатива = Новый Структура;
	
	Пока Выборка.Следующий() Цикл 
		//РезультатПр  ПроверитьТранзакциюПоДокументуНаСервере(Выборка.Ссылка);
		Инициатива.Вставить("Наименование",Выборка.Наименование);
		Инициатива.Вставить("ОценкаЛайк",Выборка.ОценкаЛайк);
		Инициатива.Вставить("ОценкаДизЛайк",Выборка.ОценкаДизЛайк);
		Инициатива.Вставить("ДоступностьЮрЛицам",Выборка.ДоступностьЮрЛицам);
		Инициатива.Вставить("ДоступностьФизЛицам",Выборка.ДоступностьФизЛицам);
		Инициатива.Вставить("СрокДо",Выборка.СрокДо);
		Результат.Вставить("КодОтвета", Истина);
		Результат.Вставить("СообщениеОбОшибке", "");
	КонецЦикла;
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

