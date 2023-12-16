import 'package:get/get.dart';

class SupportedLocales {
  const SupportedLocales._();

  static const ruRU = 'ru_RU';

  static const enUS = 'en_US';
}

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        SupportedLocales.enUS: {
          'home': 'Home',
          'transactions': 'Transactions',
          'assistant': 'Assistant',
          'welcome': 'Welcome!',
          'csv_import': 'CSV Import',
          'useful_transaction_statistics': 'Useful transaction statistics',
          'ask_assistant': 'Ask assistant',
          'settings': 'Settings',
          'language': 'Language',
          'transaction_statistics': 'Transaction statistics',
          'total_amount': 'Total amount',
          'average_amount': 'Average amount',
          'amount': 'Amount',
          'monthly_transaction_statistics': 'Monthly statistics',
          'enable_dark_mode': 'Dark mode',
          'add_transaction': 'Add transaction',
          'transaction_creation': 'Transaction creation',
          'transaction_details': 'Transaction details',
          'create': 'Create',
          'name': 'Name',
          'save': 'Save',
          'date': 'Date',
          'cancel': 'Cancel',
          'submit': 'Submit',
          'OK': 'Ok',
          'success': 'Success!',
          'delete_transaction': 'Delete transaction',
          'are_you_sure': 'Are you sure?',
          'no_transactions_found': 'No transactions found. Add several.',
          // Transaction type
          'income': 'Income',
          'expense': 'Expense',
          // Transaction category
          'none': 'Without category',
          'groceries': 'Groceries',
          'food': 'Food',
          'entertainment': 'Entertainment',
          'gas': 'Gas',
          'please_enter_transaction_name': 'Please enter transaction name',
          'please_enter_amount': 'Please enter amount',
          'choose_file': 'Choose file',
          'import_setup': 'Import setup',
          'choose_column_delimiter': 'Choose column delimiter',
          'csv_tips': 'CSV Import Tips 💡',
          'csv_import_description': 'Choose a CSV file to import transactions:',

          'column_order_tip': 'Column Order:',
          'column_order_tip_description':
              'Make sure your CSV file has columns in the correct order: title, amount, date, category, type.',
          'data_rows_tip': 'Data Rows:',
          'data_rows_tip_description':
              'Enter your transaction data in rows below the column headers.',
          'date_format_tip': 'Date Format:',
          'date_format_tip_description':
              "Use a consistent date format for the 'date' column (e.g., DD.MM.YYYY).",
          'missing_values_tip': 'Missing Values:',
          'missing_values_tip_description':
              'Leave cells empty for optional fields (e.g., category in the last row).',
          'delimiter_tip': 'Delimiter:',
          'delimiter_tip_description':
              'Select the correct delimiter (comma, semicolon, pipe, or tab) before importing.\n\nEnsure your CSV file aligns with this structure for a smooth import process. If in doubt, refer to this example or consult the documentation.',
          'comma_delimiter': 'Comma (,)',
          'semicolon_delimiter': 'Semicolon (;)',
          'pipe_delimiter': 'Pipe (|)',
          'tab_delimiter': 'Tab (\t)',
          'no_data': 'No data',
          'no_data_to_preview': 'No data to preview',

          'csv_preview': "CSV preview",
          'incorrect_csv_file': 'Incorrect CSV file structure!',
          'csv_import_successful': 'CSV was imported correctly!',
        },
        SupportedLocales.ruRU: {
          'home': 'Главная',
          'transactions': 'Транзакции',
          'assistant': 'Ассистент',
          'welcome': 'Добро пожаловать!',
          'csv_import': 'CSV импорт',
          'useful_transaction_statistics': 'Полезная статистика по транзакциям',
          'ask_assistant': 'Спросить совет у ассистента',
          'settings': 'Настройки',
          'language': 'Язык',
          'transaction_statistics': 'Статистика по транзакциям',
          'total_amount': 'Общая сумма',
          'average_amount': 'Средняя сумма',
          'amount': 'Сумма',
          'monthly_transaction_statistics': 'Статистика по месяцам',
          'enable_dark_mode': 'Темная тема',
          'add_transaction': 'Добавить транзакцию',
          'transaction_creation': 'Создание транзакции',
          'transaction_details': 'Описание транзакции',
          'create': 'Создать',
          'name': 'Название',
          'save': 'Сохранить',
          'date': 'Дата',
          'cancel': 'Отмена',
          'submit': 'Подтвердить',
          'success': 'Успех!',
          'OK': 'Хорошо',
          'delete_transaction': 'Удаление транзакции',
          'are_you_sure': 'Вы уверены?',
          'no_transactions_found': 'Транзакции не найдены. Добавьте несколько.',
          'income': 'Пополнение',
          'expense': 'Расходы',
          'none': 'Без категории',
          'groceries': 'Продукты',
          'food': 'Еда',
          'entertainment': 'Развлечения',
          'gas': 'Топливо',
          'please_enter_transaction_name': 'Введите название транзакции',
          'please_enter_amount': 'Введите сумму',
          'choose_file': 'Выбрать файл',
          'import_setup': 'Настройка импорта',
          'choose_column_delimiter': 'Выберите разделитель стоблцов',
          'csv_tips': 'Подсказки по импорту CSV 💡',
          'csv_import_description': 'Выберите CSV файл для импорта транзакций:',
          'column_order_tip': 'Порядок столбцов:',
          'column_order_tip_description':
              'Убедитесь, что в вашем файле CSV столбцы расположены в правильном порядке: заголовок, сумма, дата, категория, тип.',
          'data_rows_tip': 'Строки данных:',
          'data_rows_tip_description':
              'Введите ваши данные о транзакциях в строки ниже заголовков столбцов.',
          'date_format_tip': 'Формат даты:',
          'date_format_tip_description':
              "Используйте согласованный формат даты для столбца 'дата' (например, ДД.ММ.ГГГГ).",
          'missing_values_tip': 'Отсутствующие значения:',
          'missing_values_tip_description':
              'Оставьте ячейки пустыми для необязательных полей (например, категория в последней строке).',
          'delimiter_tip': 'Разделитель:',
          'delimiter_tip_description':
              'Выберите правильный разделитель (запятая, точка с запятой, вертикальная черта или табуляция) перед импортом.\n\nУбедитесь, что ваш файл CSV соответствует этой структуре для безпроблемного процесса импорта. В случае сомнений обратитесь к этому примеру или проконсультируйтесь с документацией.',
          'comma_delimiter': 'Запятая (,)',
          'semicolon_delimiter': 'Точка с запятой (;)',
          'pipe_delimiter': 'Вертикальная черта (|)',
          'tab_delimiter': 'Таб (\t)',
          'no_data': 'Нет данных',
          'no_data_to_preview': 'Невозможно отобразить данные из CSV',
          'csv_preview': "CSV превью",
          'incorrect_csv_file': 'Неверный формат CSV файла!',
          'csv_import_successful': 'CSV файл был успешно импортирован!3'
              ''
              ''
              ''
              ''
              ''
              ''
              ''
              '',
        },
      };
}
