'use strict';
(() => {
  const $ = id => document.getElementById(id);
  const copy = {
    ru: {heading:'Удаление аккаунта',intro:'Здесь можно удалить аккаунт без установки приложения. Войдите, чтобы подтвердить, что аккаунт принадлежит вам.',warning:'Аккаунт, категории, привычки, история, цели, распределения и настройки будут безвозвратно удалены из рабочей базы. Копии чеков, которые вы сохранили или отправили, не удаляются. Сведения о резервных копиях и журналах — в политике конфиденциальности.', 'password-label':'Пароль',authenticate:'Подтвердить вход',confirmation:'Понимаю, что все записи будут удалены безвозвратно.',delete:'Удалить аккаунт и данные',cancel:'Отмена',busy:'Выполняется…',failed:'Не удалось выполнить действие. Проверьте подключение и повторите.',unauthorized:'Email или пароль неверны либо сессия истекла. Войдите заново.',success:'Аккаунт и его данные удалены из рабочей базы.',prompt:'Безвозвратно удалить аккаунт и все связанные записи?',identity:'Подтверждён аккаунт: '},
    en: {heading:'Delete your account',intro:'Delete your account without installing the app. Sign in to verify that you own the account.',warning:'Your account, categories, habits, history, goals, allocations and settings will be permanently deleted from the active database. Receipt copies you saved or shared are not deleted. See the privacy policy for backup and log information.', 'password-label':'Password',authenticate:'Verify account',confirmation:'I understand that all records will be permanently deleted.',delete:'Delete account and data',cancel:'Cancel',busy:'Working…',failed:'The operation could not be completed. Check your connection and retry.',unauthorized:'Incorrect email/password or an expired session. Sign in again.',success:'Your account and data have been deleted from the active database.',prompt:'Permanently delete the account and all associated records?',identity:'Verified account: '}
  };
  const base = document.querySelector('meta[name=api-base]').content.replace(/\/$/, '');
  let token = '', account = '', language = 'ru', busy = false;
  const text = key => copy[language][key];
  const reset = () => { token=''; account=''; $('password').value=''; $('confirmed').checked=false; $('delete').disabled=true; $('deletion').hidden=true; $('login').hidden=false; };
  const working = value => { busy=value; $('authenticate').disabled=value; $('delete').disabled=value || !$('confirmed').checked; $('cancel').disabled=value; $('language').disabled=value; };
  $('language').addEventListener('click',()=>{language=language==='ru'?'en':'ru';document.documentElement.lang=language; for (const key of ['heading','intro','warning','password-label','authenticate','confirmation','delete','cancel']) $(key).textContent=text(key);$('language').textContent=language==='ru'?'English':'Русский';$('identity').textContent=text('identity')+account;$('status').textContent='';});
  $('confirmed').addEventListener('change',()=>{$('delete').disabled=busy || !$('confirmed').checked;});
  $('cancel').addEventListener('click',()=>{reset();$('status').textContent='';});
  window.addEventListener('pagehide',reset);
  async function request(path, options) {
    const url = new URL(base+path);
    if (url.protocol!=='https:') throw new Error('insecure');
    const response = await fetch(url,{...options, credentials:'omit',cache:'no-store',redirect:'error',signal:AbortSignal.timeout(30000)});
    if (!response.ok) { const error = new Error('request'); error.status=response.status; throw error; }
    return response;
  }
  function failed(error) {const unauthorized=error.status===401 || error.status===403; if(unauthorized) reset(); $('status').textContent=text(unauthorized?'unauthorized':'failed');}
  $('login').addEventListener('submit',async event=>{
    event.preventDefault(); if(busy || !$('login').reportValidity()) return;
    working(true); $('status').textContent=text('busy');
    try {
      const email=$('email').value.trim().toLowerCase();
      const response=await request('/auth/login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email,password:$('password').value})});
      const result=await response.json();
      if(typeof result.data?.access_token!=='string' || !result.data.access_token) throw new Error('contract');
      token=result.data.access_token;account=email;$('password').value='';$('login').hidden=true;$('deletion').hidden=false;$('identity').textContent=text('identity')+email;$('status').textContent='';$('confirmed').focus();
    } catch(error) {failed(error);} finally {$('password').value='';working(false);}
  });
  $('delete').addEventListener('click',async()=>{
    if(busy || !token || !$('confirmed').checked || !window.confirm(text('prompt'))) return;
    working(true);$('status').textContent=text('busy');
    try {await request('/users/',{method:'DELETE',headers:{Authorization:'Bearer '+token}});reset();$('login').hidden=true;$('status').textContent=text('success');}
    catch(error) {failed(error);} finally {working(false);}
  });
})();
