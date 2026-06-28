<?php
declare(strict_types=1);

/**
 * Example configuration for the anonymized university attendance system.
 *
 * Local setup:
 * 1. Copy this file to config.php.
 * 2. Set real values through environment variables or your local-only copy.
 * 3. Never commit config.php, real passwords, HMAC secrets, internal IPs, or production paths.
 */

date_default_timezone_set((string)(getenv('AIS_TIMEZONE') ?: 'Europe/Moscow'));

if (!defined('SITE_NAME')) {
    define('SITE_NAME', 'University Attendance Management System');
}
if (!defined('SITE_URL')) {
    define('SITE_URL', rtrim((string)(getenv('AIS_SITE_URL') ?: 'http://localhost/ais-attendance/'), '/') . '/');
}
if (!defined('API_URL')) {
    define('API_URL', SITE_URL . 'api.php');
}
if (!defined('SESSION_LIFETIME_MINUTES')) {
    define('SESSION_LIFETIME_MINUTES', (int)(getenv('AIS_SESSION_LIFETIME_MINUTES') ?: 480));
}
if (!defined('DEBUG_MODE')) {
    define('DEBUG_MODE', filter_var(getenv('AIS_DEBUG') ?: 'false', FILTER_VALIDATE_BOOL));
}

if (!defined('SKUD_SHARED_SECRET')) {
    define('SKUD_SHARED_SECRET', getenv('AIS_SKUD_SECRET') ?: 'CHANGE_ME');
}
if (!defined('INTEGRATION_HEALTH_SECRET')) {
    define('INTEGRATION_HEALTH_SECRET', getenv('AIS_HEALTH_SECRET') ?: 'CHANGE_ME');
}
if (!defined('INTEGRATION_ALLOWLIST')) {
    define('INTEGRATION_ALLOWLIST', getenv('AIS_INTEGRATION_ALLOWLIST') ?: '127.0.0.1,::1');
}

function getEnvValue(string $name, string $default = ''): string {
    $value = getenv($name);
    if ($value === false || $value === '') {
        return $default;
    }
    return (string)$value;
}

function getEnvBool(string $name, bool $default): bool {
    $value = getenv($name);
    if ($value === false || $value === '') {
        return $default;
    }

    $parsed = filter_var($value, FILTER_VALIDATE_BOOL, FILTER_NULL_ON_FAILURE);
    return $parsed === null ? $default : $parsed;
}

$serverName = sprintf(
    '%s,%s',
    getEnvValue('AIS_DB_HOST', 'localhost'),
    getEnvValue('AIS_DB_PORT', '1433')
);

$connectionOptions = [
    'Database' => getEnvValue('AIS_DB_NAME', 'UniversityAttendance'),
    'Uid' => getEnvValue('AIS_DB_USER', 'CHANGE_ME'),
    'PWD' => getEnvValue('AIS_DB_PASSWORD', 'CHANGE_ME'),
    'CharacterSet' => 'UTF-8',
    'ReturnDatesAsStrings' => true,
    'Encrypt' => getEnvBool('AIS_DB_ENCRYPT', false),
    'TrustServerCertificate' => getEnvBool('AIS_DB_TRUST_SERVER_CERT', true),
];

function ensureSessionStorageReady(): void {
    if (session_status() !== PHP_SESSION_NONE) {
        return;
    }

    $currentPath = (string)ini_get('session.save_path');
    if ($currentPath !== '' && is_dir($currentPath) && is_writable($currentPath)) {
        return;
    }

    $fallbackPath = __DIR__ . DIRECTORY_SEPARATOR . 'runtime' . DIRECTORY_SEPARATOR . 'sessions';
    if (!is_dir($fallbackPath)) {
        @mkdir($fallbackPath, 0777, true);
    }

    if (is_dir($fallbackPath) && is_writable($fallbackPath)) {
        session_save_path($fallbackPath);
    }
}

function startSessionIfNeeded(): void {
    if (session_status() === PHP_SESSION_NONE) {
        ensureSessionStorageReady();
        session_start();
    }
}

function ensureSqlsrvExtensionLoaded(): void {
    if (!extension_loaded('sqlsrv')) {
        throw new RuntimeException('PHP extension "sqlsrv" is not loaded.');
    }
}

function getSqlsrvErrorsText(): string {
    $errors = sqlsrv_errors(SQLSRV_ERR_ERRORS);
    if (!is_array($errors) || empty($errors)) {
        return 'Unknown SQLSRV error.';
    }

    $messages = [];
    foreach ($errors as $error) {
        $state = isset($error['SQLSTATE']) ? (string)$error['SQLSTATE'] : 'N/A';
        $code = isset($error['code']) ? (string)$error['code'] : 'N/A';
        $message = isset($error['message']) ? trim((string)$error['message']) : 'No message';
        $messages[] = sprintf('[%s/%s] %s', $state, $code, $message);
    }

    return implode(' | ', $messages);
}

function getDBConnection() {
    global $serverName, $connectionOptions;

    ensureSqlsrvExtensionLoaded();

    $conn = sqlsrv_connect($serverName, $connectionOptions);
    if ($conn === false) {
        throw new RuntimeException('Database connection failed: ' . getSqlsrvErrorsText());
    }

    return $conn;
}

function closeDBConnection($conn): void {
    if (is_resource($conn) || $conn !== null) {
        @sqlsrv_close($conn);
    }
}

function normalizeScalarValue($value) {
    if ($value instanceof DateTimeInterface) {
        return $value->format('Y-m-d H:i:s');
    }
    return $value;
}

function jsonResponse(bool $success, $data = null, string $message = '', ?int $errorCode = null, int $httpStatus = 200): void {
    if (!headers_sent()) {
        http_response_code($httpStatus);
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
    }

    $response = [
        'success' => $success,
        'data' => $data,
        'message' => $message,
    ];

    if ($errorCode !== null) {
        $response['error_code'] = $errorCode;
    }

    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}
