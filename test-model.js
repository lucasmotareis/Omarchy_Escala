const assert = require('node:assert/strict')
const fs = require('node:fs')
const vm = require('node:vm')

const source = fs.readFileSync(__dirname + '/ShiftModel.js', 'utf8').replace(/^\.pragma library\s*/, '')
const context = { module: { exports: {} } }
vm.runInNewContext(source, context)
const model = context.module.exports
const anchor = '2026-10-21'
const state = (key, overrides = {}) => model.status(key, anchor, 2, 6, overrides)

assert.equal(state(anchor), 'service')
assert.equal(state('2026-10-22'), 'service')
assert.equal(state('2026-10-23'), 'off')
assert.equal(state('2026-10-29'), 'service')
assert.equal(state('2026-10-20'), 'off')
assert.equal(model.nextService('2026-10-23', anchor, 2, 6, {}), '2026-10-29')
assert.equal(model.nextService('2026-10-23', anchor, 2, 6, { '2026-10-25': 'service' }), '2026-10-25')
assert.equal(model.nextService('2026-10-29', anchor, 2, 6, { '2026-10-29': 'off', '2026-10-30': 'off' }), '2026-11-06')
assert.equal(model.nextService('2026-10-23', '', 2, 6, { '2026-11-01': 'service' }), '2026-11-01')
assert.equal(model.dayNumber('2026-02-29'), null)
assert.notEqual(model.dayNumber('2028-02-29'), null)
const added = model.toggledOverrides('2026-10-25', anchor, 2, 6, {})
assert.equal(added['2026-10-25'], 'service')
assert.equal(Object.keys(model.toggledOverrides('2026-10-25', anchor, 2, 6, added)).length, 0)
console.log('Cálculo da escala: OK')
