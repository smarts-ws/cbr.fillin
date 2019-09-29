﻿// Функция позволяет из данных типа ФорматированныйДокумент получить ТекстHTML для вставки в документ типа HTML
//
// Параметры:
// ФорматированныйДокумент	- объект одноименного типа для разбора и парсинга с последующей конветацией в чистый HTML код для вставки

Функция ПолучитьТекстHTMLВставкиФорматированногоДокумента(ФорматированныйДокумент) Экспорт
	// Обрабатываем комментарии
	ТекстHTML					= "";
	СтруктураВложений			= Новый Структура;
	ФорматированныйДокумент.ПолучитьHTML(ТекстHTML, СтруктураВложений); 
	// Получаем чистый HTML код вложений тела ФД
	п1 = Найти(ТекстHTML, "<body>"); 
	п2 = Найти(ТекстHTML, "</body>");
	
	ТекстHTML =СокрЛП(СтрЗаменить(Сред(ТекстHTML, п1, п2 - п1), "<body>", "")); 
	// Обрабатываем вложения и кодируем для вставки в HTML код
	Для Каждого ЭлементВложения Из СтруктураВложений Цикл
		Ключ		= ЭлементВложения.Ключ;
		Вложение	= ЭлементВложения.Значение;
		
		ФорматПикчи	= Вложение.Формат();
		
		КартинкаВКодировкеBase64= Base64Строка(Вложение.ПолучитьДвоичныеДанные());
		СтрокаПодстановкиHTML	= "data:image/"+ФорматПикчи+";base64,"+КартинкаВКодировкеBase64;
		ТекстHTML				= СтрЗаменить(ТекстHTML, Ключ, СтрокаПодстановкиHTML);
	КонецЦикла;
	// Вернем готовый текст HTML
	Возврат ТекстHTML;
КонецФункции