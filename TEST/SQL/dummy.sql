SELECT plan(3);
SELECT ok(true,'this will pass');
SELECT ok(random()>0.5,'thou shall maybe not pass');
SELECT ok(true,'why did you pass?');
SELECT * FROM finish();
