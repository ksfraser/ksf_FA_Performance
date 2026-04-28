<?php
$module_id = 'Performance'; $module_version = '1.0.0'; $module_name = 'Performance Management'; $module_description = 'Employee performance reviews and goals';
$module_tables = ['fa_performance_reviews', 'fa_performance_goals']; $module_capabilities = ['SA_PERFORMANCEVIEW'=>'View Reviews','SA_PERFORMANCECREATE'=>'Create Reviews','SA_PERFORMANCEMANAGE'=>'Manage Goals'];
function performance_install():bool{return install_module_sql('Performance');}function performance_enable():bool{return enable_module('Performance');}function performance_disable():bool{return disable_module('Performance');}function performance_remove():bool{return remove_module_sql('Performance');}
add_module($module_name,$module_version,$module_description);