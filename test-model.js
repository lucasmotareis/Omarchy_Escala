const assert = require('node:assert/strict')
const model = require('./Model.js')

const anchor = '2026-10-14'
const status = (key, overrides = {}) => model.shiftState(key, anchor, 2, 6, overrides)

assert.equal(status(anchor), 'service')
assert.equal(status('2026-10-15'), 'service')
assert.equal(status('2026-10-16'), 'off')
assert.equal(status('2026-10-22'), 'service')
assert.equal(status('2026-10-13'), 'off')
assert.equal(model.nextServiceKey('2026-10-16', anchor, 2, 6, {}), '2026-10-22')
assert.equal(model.nextServiceKey('2026-10-16', anchor, 2, 6, { '2026-10-18': 'service' }), '2026-10-18')
assert.equal(model.nextServiceKey('2026-10-22', anchor, 2, 6, { '2026-10-22': 'off', '2026-10-23': 'off' }), '2026-10-30')
assert.equal(model.nextServiceKey('2026-10-16', '', 2, 6, { '2026-11-01': 'service' }), '2026-11-01')
assert.equal(model.dayNumber('2026-02-29'), null)
assert.equal(model.dayNumber('2028-02-29') !== null, true)
assert.equal(model.shiftState('2026-03-09', '2026-03-07', 2, 6, {}), 'off')
console.log('Cálculo da escala: OK')
