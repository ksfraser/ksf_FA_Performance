<?php

declare(strict_types=1);

namespace Ksfraser\Tests\Unit\FA\Performance;

use PHPUnit\Framework\TestCase;

/**
 * The employee-name lookup in includes/performance_db.inc used to join
 * `TB_PREF . "hr_employees"`, a table that exists in neither FA core nor any
 * schema in this estate. The join therefore failed with MySQL error 1146 on
 * every review list query, and because db_query() swallows the error when no
 * message is supplied, the failure was invisible: the list simply came back
 * empty.
 *
 * The employee directory is module-local (`0_ksf_performance_employees`)
 * because FA has no employee entity - see the comment in sql/install.sql.
 */
class EmployeeTableTest extends TestCase
{
    private const EMPLOYEE_TABLE = 'ksf_performance_employees';

    private string $moduleDir;

    protected function setUp(): void
    {
        $this->moduleDir = dirname(__DIR__, 2);
    }

    public function testPerformanceDbDoesNotJoinTheNonExistentHrEmployeesTable(): void
    {
        $contents = (string) file_get_contents($this->moduleDir . '/includes/performance_db.inc');

        $this->assertStringNotContainsString(
            'hr_employees',
            $contents,
            'includes/performance_db.inc must not address 0_hr_employees: that table is created by no schema'
        );
    }

    public function testPerformanceDbJoinsTheModuleLocalEmployeeDirectory(): void
    {
        $contents = (string) file_get_contents($this->moduleDir . '/includes/performance_db.inc');

        $this->assertStringContainsString(
            'TB_PREF."' . self::EMPLOYEE_TABLE . ' ',
            $contents,
            'the employee name must come from the module-owned directory table'
        );
    }

    public function testSchemaCreatesTheEmployeeDirectory(): void
    {
        $contents = (string) file_get_contents($this->moduleDir . '/sql/install.sql');

        $this->assertStringContainsString(
            'CREATE TABLE IF NOT EXISTS `0_' . self::EMPLOYEE_TABLE . '`',
            $contents,
            'sql/install.sql must create the table the code joins'
        );
    }

    public function testEmployeeDirectoryCarriesTheColumnsTheQueriesSelect(): void
    {
        $contents = (string) file_get_contents($this->moduleDir . '/sql/install.sql');

        $this->assertStringContainsString('`name`', $contents);
        $this->assertStringContainsString('`active`', $contents);
    }
}
