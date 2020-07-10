# PROJECT 01

## Introduction
<br>
저는 이번 과제에서 다음과 같은 디자인을 추구하였습니다.
<br>
> 1. 효율적인 관리를 위해 기존의 ptable은 놔두고 그것을 바라보는 테이블을 따로 만들자.
> 2. stride scheduling이 상위 스케줄링이고 그 아래에 MLFQ를 관리하는 스케줄링을 놓자.

<br>
최대한 코드를 함수화시켜서 설계에 반복적인 작업에 오버헤드가 없도록 하였습니다.

<br>
___
## Design
<br>
제 디자인을 소개해드리겠습니다.

scheduler가 실행되면 다음 선택될 프로세스를 정하기 위한 과정에 들어갑니다.

pick_stride함수가 실행되어 s_table을 순회하면서 현재 pass가 가장 작은 stride를 선택하게 됩니다.

만약, 선택된 stride가 s_table[0]에 있는 stride라면 이를 MLFQ로 처리하기 위해 pick_mlfq를 실행하게 됩니다.

MLFQ의 경우 각 queue마다 최근에 뽑혔던 mlfq_node를 저장해놓는 변수를 통해 다음 pick_mlfq에도 같은 mlfq_node가 뽑히지 않도록 했습니다.

![design1](/uploads/df5ddd2668671686c6d1cedb8e6fe0de/design1.png)

Time quantum 과 Time allotment는 과제에 나와있는대로 구현했습니다.

> Time quantum
> - The highest priority : 1 tick
> - Middle priority : 2 ticks
> - The lowest priority : 4 ticks
>
> Time allotment
>  - The highest priority : 5 ticks
>  - The middle priority : 10 ticks

마지막으로, user가 프로그램의 cpu_share을 조종하는 것을 막기위해

각, mlfq_node마다 경과된 ticks들을 저장하는 eticks 변수를 만들었습니다.

각 1 tick마다 eticks들을 계산해주어 경과된 ticks을 계산하기 때문에

우선순위의 변경 전에 yield를 통해 cpu를 점유하는 것을 막을 수 있습니다.

___
## Analysis

<br>

분석에 대한 신뢰성을 위해 여러번 시도 해봤습니다.

<br>

첫번째 시도,

![test_master1](/uploads/e7ef2c9aaf9c2e22906afba44e8398eb/test_master1.png)

<br>

두번째 시도,

![test_master2](/uploads/bcf1826dfb8160c069599e495a905098/test_master2.png)

<br>

세번째 시도,

![test_master3](/uploads/d61e60b025618f2b70228dfad0406c79/test_master3.png)

<br>

3번의 시도에서 비슷한 경향을 띄고 있습니다.

여기서, 다음과 같은 점에 대해 살펴보겠습니다.

> 1. 계획된 time quantum과 time allotment를 잘 수행하고 있는지?
> 2. priority boosing이 잘 이루어지고 있는지?
> 3. cpu_share만큼 잘 동작하고 있는지?

<br>

**1. 계획된 time quantum과 time allotment를 잘 수행하고 있는지?**

time quantum은 자료를 보고 알 수 없지만 time allotment는 1 : 2 : 6의 비율로 잘 이루어지고 있는 것을 확인 할 수 있습니다.

이는 highest priority의 할당이 5 ticks이고 middle priority의 할당이 10 ticks이므로 1 : 2의 비율로 잘 돌아가고 있는 것을 알 수 있습니다.

<br>

**2. priority boosing이 잘 이루어지고 있는지?**

이는 MLFQ(yield)와 MLFQ(compute)를 보면 확인 할 수 있습니다.

MLFQ(yield)는 일부로 yield를 수행하기 때문에 cpu를 과점하게 되는데

실제로는 MLFQ(yield)와 MLFQ(compute)의 값이 비슷한 것으로 보아 priority boosting이 잘 일어나고 있는 것을 확인 할 수 있습니다.

<br>

**3. cpu_share만큼 잘 동작하고 있는지?**

stride(10%) 는 400~450만큼의 값을 stride(40%)는 1600~1700만큼의 값을 나타내는 것으로 보아

1 : 4의 비율로 cpu_share를 점유하고 있는 것을 확인 할 수 있습니다.

<br>

다음과 같이 3가지 점을 확인하여 디자인대로 스케줄링이 잘 되고 있는 것을 확인 할 수 있습니다.

<br>

___

<br>



# Project 02



## 1. Process / Thread

### 프로세스와 쓰레드

프로세스는 한 cpu에서 돌아가는 프로그램입니다.

리소스를 공유하지 않기 때문에 각 프로세스간의 통신을 위해서는 시스템 콜을 통한 통신이 필요합니다.

반면, 쓰레드는 리소스를 공유하는 프로그램입니다.

쓰레드 간 리소스를 공유하기 때문에 같은 메모리 참조가 비교적 쉽습니다.

다만, 스택과 같이 다른 부분도 존재합니다.

<br>

### 콘텍스트 스위칭

메모리를 공유한다는 점을 알면 쓰레드가 왜 light weight thread라고 불리는 지 이해할 수 있습니다.

프로그램이 돌아가면서 메모리 계층 구조를 통해 캐시 히트가 나면 동작에 대한 오버헤드가 줄어듭니다.

프로세스는 캐시에 저장된 메모리들이 컨텍스트 스위칭 후 모두 필요없어지기 때문에 캐시 미스에 대한 부담이 커집니다.

하지만, 쓰레드는 컨텍스트 스위칭 후 캐시에 저장된 메모리를 교체된 쓰레드가 사용할 수 있기 때문에 캐시 미스에 대한 부담이 적어 프로세스에 비해 가벼운 편입니다.

<br>

## 2. Design

### 이해의 시간

xv6를 디자인 하는 것은 쉽지 않았습니다.

남이 짜놓은 코드를 가지고 원하는 대로 고치는 것은 처음부터 코드를 만드는 것과는 많이 달랐습니다.

코드를 이해하기 위해 전체 코드를 수없이 훑어보고 이해해야 했습니다.

코드를 이해한 뒤에는 효율적이지만 복잡한 방식을 써야할 지

아니면 간단하지만 비효율적인 방식을 써야할 지 선택해야 했습니다.

효율적으로 짠다면 속도는 빨라지겠지만 제 머리가 감당할 수 있는 수준으로 타협하였습니다.

<br>

### MLFQ와 STRIDE sched의 구현

![sched1](/uploads/8e2a4653946f897d2f8cc6b90c763c87/sched1.png)

과제에 나온 MLFQ와 STRIDE 스케줄링을 구현하기 위해서 project01에서 구현 해놓은 스케줄러를 이용하기로 했습니다.

<br>

### LWP의 구현

![proc1](/uploads/27484380d244dde90d89f89a094ee408/proc1.png)

LWP의 구현을 위해서 저는 proc구조체를 사용하기로 했습니다.

proc 구조체를 이용한다면 만들어져 있는 라이브러리와 호환이 간편할 것으로 생각했습니다.

> `retVal` : threadexit을 통한 리턴 값을 얻기 위한 변수입니다.
>
> `tid` : tid를 통해서 주인 쓰레드를 구별 할 수 있습니다.
>
> `master` : 주인쓰레드를 가르키는 포인터입니다.
>
> `base` : 각 쓰레드가 점유하고 있는 스택의 시작 부분을 나타냅니다.
>
> `cur` : 주인쓰레드에서만 쓰입니다. **fairness**를 위하여 마지막으로 실행됬던 쓰레드를 저장합니다.
>
> `stack_size` : 주인쓰레드에서만 쓰입니다. stack 변수를 위해 존재합니다.
>
> `stack` : 말그대로 값을 저장하는 스택입니다. 주인쓰레드에서 값을 할당하지 않은 부분을 참조하기 위해 쓰입니다.

<br>

### LWP의 행동

LWP을 하나의 그룹으로 생각하면 디자인이 간편해집니다.

![untitled__1_](/uploads/b097fa31fba440053ed249d169a66c31/untitled__1_.png)

이 그림을 이해했다면 LWP의 행동을 이해 할 수 있습니다.

> `Basic Operations` : LWP의 같은 그룹은 MLFQ의 STRIDE 스케줄링을 공유합니다. 즉, 같은 time quantum과 time allotment를 공유하기 때문에 아무리 LWP의 수를 늘린다하여도 CPU를 점유하는 비율은 똑같습니다.
>
> `Exit` : 만약, LWP의 어느 한 쓰레드라도 종료를 선언하면 전체 LWP 그룹의 모든 LWP가 동작을 멈추고 좀비상태가 됩니다. 
>
> `Fork` : 만약, 주인쓰레드가 fork를 실행하면 기존의 fork와 동일하게 실행됩니다. 그러나, 주인 쓰레드가 아닌 쓰레드가 fork를 실행하면 parent는 fork를 실행한 LWP그룹이 되고 fork로 나온 자식 쓰레드는 새로운 LWP그룹으로 떨어져 나오게 됩니다.
>
> `Exec` : 만약, 어느 쓰레드라도 exec를 실행한다면 모든 LWP를 좀비로 만들고 exec를 실행한 쓰레드만이 새로운 LWP그룹을 만들게 됩니다.
>
> `Sbrk` : 모든 LWP 구성원들은 pgdir을 공유하기 때문에 메모리 사이즈도 LWP 그룹과 같습니다. 이를 구현하기 위해서 주인 쓰레드의 메모리 사이즈를 참조합니다.
>
> `Kill` : 쓰레드가 죽는다면 그 LWP그룹은 모두 죽습니다.  이를 구현하기 위해 같은 LWP 그룹을 모두 killed상태로 만듭니다.
>
> `Pipe` : 모든 LWP는 파이프를 공유합니다. 파이프를 공유하기 때문에 동기화가 됩니다.
>
> `Sleep` : lwp의 sleep은 개별로 실행됩니다. 즉, LWP 그룹 전체가 하나의 LWP sleep에 잠들지 않습니다.
>

<br>

## 3. Results of execution

<br>

test_thread2의 테스트 코드로 설명하겠습니다.

<br>

### 0. racingtest

![test0](/uploads/e1c665b5468e2f0bfa3cc7d39791403c/test0.png)

하나의 변수를 가지고 여러 개의 쓰레드가 값을 올리기 때문에 레이스 현상이 나타납니다.

이 현상은 한 쓰레드가 값을 읽고 저장하는 사이에 다른 쓰레드도 읽고 저장하는 작동을 하기 때문에 생겨납니다.

### 1. basictest

![test1](/uploads/ed0eed0452f25c567d8f716a3ed6d41e/test1.png)

각각의 쓰레드가 실행되는 순서가 정해져 있지 않기 때문에 0~9까지의 숫자가 무작위로 나타나게 됩니다.

### 2. jointest

![test2](/uploads/d432fa42f701fbc47fd8f4bc6d665794/test2.png)

jointest1은 exit전에 join이 먼저 실행됬을 때를 나타냅니다.

jointest2는 exit후에 join이 실행 됬을 때를 나타냅니다.

둘 다 정상적으로 작동하는 것을 짐작 할 수 있습니다.

### 3. stresstest

![test3](/uploads/631ac03c6b1e5ec3019ab63737888ec9/test3.png)

스트레스 테스트는 쓰레드의 create와 join이 수만 단위로 진행되면 어떻게 되는지 보여줍니다.

여기서 메모리 관련 에러가 나지 않는 것으로 보아 정상적으로 작동 함을 알 수 있습니다.

### 4. exit test

exittest는 exit없이 쓰레드가 종료되거나 주인 쓰레드가 먼저 종료될 시 상황을 보여줍니다.

관련 에러가 뜨지 않는 걸로 보아 정상적으로 동작하는 것으로 추측됩니다.

### 5. forktest

![test4](/uploads/717e88df31815efc49800adf3005602d/test4.png)

forktest는 쓰레드 안에서의 fork를 처리할 수 있는지 보여줍니다.

쓰레드 안에서 fork가 일어나도 정상적으로 작동 함을 볼 수 있습니다.

### 6. exectest

![test5](/uploads/7d73ab4d691213862da03c9a4322dccb/test5.png)

exectest는 여러 exec가 동시에 일어나도 LWP 그룹의 자원을 모두 지우고 하나의 exec만 실행 됨을 볼 수 있습니다.

### 7. sbrktest, killtest, pipetest

![test6](/uploads/93cfeb5c900c41caa0591114c3506d35/test6.png)

sbrktest, killtest, piptest는 관련 에러메시지가 나오지 않는 것으로 보아 잘 동작됨을 볼 수 있습니다.

### 8. sleeptest

![test7](/uploads/a30668984c0e5e89c7befcae17ea2138/test7.png)

sleeptest는 자식 쓰레드의 긴 sleep이 적용 되지 않는 것으로 보아 개별적으로 동작하는 구현이 된 것을 확인 할 수 있습니다.

### 9. stridetest

![test8](/uploads/d3a4feda2e2981290ae6b0260457ef60/test8.png)

마지막으로 stridetest는 각 LWP 그룹대로 stride 스케줄링이 된 것으로 2 : 10의 비율을 근사하게 가지고 있음을 확인 할 수 있습니다.