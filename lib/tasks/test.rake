desc 'Run all tests'
task :test => ['test:units', 'test:functionals', 'test:integration', 'test:javascript']
