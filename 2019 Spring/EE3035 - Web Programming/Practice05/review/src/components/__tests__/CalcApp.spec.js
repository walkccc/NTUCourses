import React from 'react';
import { mount } from 'enzyme';

import CalcApp from '../../containers/CalcApp';
import CalcButton from '../CalcButton';

it('render button correctly', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');
  const row0 = rows.at(0);
  expect(row0.find(CalcButton).at(0).text()).toBe('AC');
  expect(row0.find(CalcButton).at(1).text()).toBe('+/-');
  expect(row0.find(CalcButton).at(2).text()).toBe('%');
  expect(row0.find(CalcButton).at(3).text()).toBe('÷');

  const row1 = rows.at(1);
  expect(row1.find(CalcButton).at(0).text()).toBe('7');
  expect(row1.find(CalcButton).at(1).text()).toBe('8');
  expect(row1.find(CalcButton).at(2).text()).toBe('9');
  expect(row1.find(CalcButton).at(3).text()).toBe('x');

  const row2 = rows.at(2);
  expect(row2.find(CalcButton).at(0).text()).toBe('4');
  expect(row2.find(CalcButton).at(1).text()).toBe('5');
  expect(row2.find(CalcButton).at(2).text()).toBe('6');
  expect(row2.find(CalcButton).at(3).text()).toBe('-');

  const row3 = rows.at(3);
  expect(row3.find(CalcButton).at(0).text()).toBe('1');
  expect(row3.find(CalcButton).at(1).text()).toBe('2');
  expect(row3.find(CalcButton).at(2).text()).toBe('3');
  expect(row3.find(CalcButton).at(3).text()).toBe('+');

  const row4 = rows.at(4);
  expect(row4.find(CalcButton).at(0).text()).toBe('0');
  expect(row4.find(CalcButton).at(1).text()).toBe('.');
  expect(row4.find(CalcButton).at(2).text()).toBe('=');
});


it('7 8 9 -> 789', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row1 = rows.at(1);
  const btn7 = row1.find(CalcButton).at(0);
  const btn8 = row1.find(CalcButton).at(1);
  const btn9 = row1.find(CalcButton).at(2);

  btn7.simulate('click');
  btn8.simulate('click');
  btn9.simulate('click');

  expect(app.find('.calc-display').text()).toBe('789');
});


it('7 8 9 - 8 = -> 781', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row1 = rows.at(1);
  const btn7 = row1.find(CalcButton).at(0);
  const btn8 = row1.find(CalcButton).at(1);
  const btn9 = row1.find(CalcButton).at(2);

  const row2 = rows.at(2);
  const btnMinus = row2.find(CalcButton).at(3);

  const row4 = rows.at(4);
  const btnEqual = row4.find(CalcButton).at(2);

  btn7.simulate('click');
  btn8.simulate('click');
  btn9.simulate('click');
  btnMinus.simulate('click');
  btn8.simulate('click');
  btnEqual.simulate('click');

  expect(app.find('.calc-display').text()).toBe('781');
});


it('7 - 8 -> 8', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row1 = rows.at(1);
  const btn7 = row1.find(CalcButton).at(0);
  const btn8 = row1.find(CalcButton).at(1);

  const row2 = rows.at(2);
  const btnMinus = row2.find(CalcButton).at(3);

  btn7.simulate('click');
  btnMinus.simulate('click');
  btn8.simulate('click');

  expect(app.find('.calc-display').text()).toBe('8');
});


it('7 - + 8 -> 15', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row1 = rows.at(1);
  const btn7 = row1.find(CalcButton).at(0);
  const btn8 = row1.find(CalcButton).at(1);

  const row2 = rows.at(2);
  const btnMinus = row2.find(CalcButton).at(3);

  const row3 = rows.at(3);
  const btnAdd = row3.find(CalcButton).at(3);

  btn7.simulate('click');
  btnMinus.simulate('click');
  btnAdd.simulate('click');
  btn8.simulate('click');

  expect(app.find('.calc-display').text()).toBe('8');
});


it('7 - + 8 - -> 15', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row1 = rows.at(1);
  const btn7 = row1.find(CalcButton).at(0);
  const btn8 = row1.find(CalcButton).at(1);

  const row2 = rows.at(2);
  const btnMinus = row2.find(CalcButton).at(3);

  const row3 = rows.at(3);
  const btnAdd = row3.find(CalcButton).at(3);

  btn7.simulate('click');
  btnMinus.simulate('click');
  btnAdd.simulate('click');
  btn8.simulate('click');
  btnMinus.simulate('click');

  expect(app.find('.calc-display').text()).toBe('15');
});


it('7 8 9 - 8 - -> 781', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row1 = rows.at(1);
  const btn7 = row1.find(CalcButton).at(0);
  const btn8 = row1.find(CalcButton).at(1);
  const btn9 = row1.find(CalcButton).at(2);

  const row2 = rows.at(2);
  const btnMinus = row2.find(CalcButton).at(3);

  btn7.simulate('click');
  btn8.simulate('click');
  btn9.simulate('click');
  btnMinus.simulate('click');
  btn8.simulate('click');
  btnMinus.simulate('click');

  expect(app.find('.calc-display').text()).toBe('781');
});


it('4 * 5 = 0 -> 0', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row2 = rows.at(2);
  const btn4 = row2.find(CalcButton).at(0);
  const btn5 = row2.find(CalcButton).at(1);

  const row1 = rows.at(1);
  const btnMultiple = row1.find(CalcButton).at(3);

  const row4 = rows.at(4);
  const btn0 = row4.find(CalcButton).at(0);
  const btnEqual = row4.find(CalcButton).at(2);

  btn4.simulate('click');
  btnMultiple.simulate('click');
  btn5.simulate('click');
  btnEqual.simulate('click');
  btn0.simulate('click');

  expect(app.find('.calc-display').text()).toBe('0');
});


it('1 + 2 = 3 = -> 5', () => {
  const app = mount(<CalcApp />);

  const rows = app.find('.calc-row');

  const row3 = rows.at(3);
  const btn1 = row3.find(CalcButton).at(0);
  const btn2 = row3.find(CalcButton).at(1);
  const btn3 = row3.find(CalcButton).at(2);
  const btnAdd = row3.find(CalcButton).at(3);

  const row4 = rows.at(4);
  const btnEqual = row4.find(CalcButton).at(2);

  btn1.simulate('click');
  btnAdd.simulate('click');
  btn2.simulate('click');
  btnEqual.simulate('click');
  btn3.simulate('click');
  btnEqual.simulate('click');

  expect(app.find('.calc-display').text()).toBe('5');
});


it('AC should clear state', () => {
  const app = mount(<CalcApp />);

  const initialState = app.state();

  const rows = app.find('.calc-row');
  const row0 = rows.at(0);
  const AC = row0.find(CalcButton).at(0);

  const row1 = rows.at(1);
  const btn7 = row1.find(CalcButton).at(0);

  btn7.simulate('click');
  AC.simulate('click');

  expect(app.state()).toEqual(initialState);
});

