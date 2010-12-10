:func MkSingleton()
:   return "private static $_instance = false\n\nprivate function __construct()\n{\n}\n\npublic static function getInstance()\n{\n    if (!self::$_instance) {\n        self::$_instance = new self();\n    }\n    return self::$_instance;\n}\n"
: endfunc
