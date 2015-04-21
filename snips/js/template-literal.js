function htmlEscape(str) {
  return str.replace(/&/g, '&amp;') // first!
            .replace(/>/g, '&gt;')
            .replace(/</g, '&lt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
            .replace(/`/g, '&#96;');
}

function html(lits, ...substs) {
   return lits.raw.reduce((pre, curr, i)=> {
      if (substs[i] === undefined) return `${pre}${curr}`;
      return `${pre}${curr}${htmlEscape(substs[i])}`;
   }, "");
}

let userTmpl = user => html`
<div>
   <a href="https://${user.name}:${user.pass}@example.com/>${user.name}</a>
</div>
`;

userTmpl({ name: 'Jxck', pass: 'hoge'});