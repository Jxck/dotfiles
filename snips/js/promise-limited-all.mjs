'use strict';

export default async function PromiseLimit(num, tasks) {
  function PromiseTask(tasks) {
    // task loop
    return new Promise(async (done, fail) => {
      const results = {
        fulfilled: [],
        rejected:  [],
      }
      while(tasks.length) {
        const task = tasks.shift()
        try {
          const result = await new Promise(task)
          results.fulfilled.push(result)
        } catch(err) {
          results.rejected.push(err)
        }
      }
      done(results)
    })
  }

  return new Promise(async (done, fail) => {
    // fork worker upto num
    const promises = [...Array(num)].map((n, i) => PromiseTask(tasks))
    const results  = (await Promise.all(promises)).reduce((acc, cur) => {
      return {
        fulfilled: [...acc.fulfilled, ...cur.fulfilled],
        rejected:  [...acc.rejected,  ...cur.rejected],
      }
    }, {fulfilled:[], rejected:[]})
    done(results)
  })
}


async function main() {
  const times = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17].map((t) => t*10)
  const num   = 3
  const result = await PromiseLimit(num, times.map((time) => {
    return (done, fail) => {
      console.log(`start: ${time}`)
      setTimeout(() => {
        if (time == 100) fail(time)
        done(time)
        console.log(`done: ${time}`)
      }, time)
    }
  }))
  console.table(result)
}

// main()
