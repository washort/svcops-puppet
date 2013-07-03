# defines dreadnot stack
define dreadnot::stack(
    $instance_name,
    $stack # content of stack
) {
    $stack_name = $name

    file {
        "/etc/dreadnot.d/${instance_name}/stacks/${stack_name}.js":
            require => Dreadnot::Instance[$instance_name],
            content => $stack;
    }
}
