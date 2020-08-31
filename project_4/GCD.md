### GCD and Queues


GCD is a lib that apple crated for IOS/OS X to deal with threads. Dealing directly with threads

is dangerous, so GCD is away to make concurrent programs.

- How does GCD create threads.

The GCD does not let you create threads instead, you create a queue of closures.



### Queues


A queue similar to the one found in a SM represents the queue in the GCD lib, and each customer is a closures who is waiting for the cashier.


A cashier is a thread that picks a customer/closure and allows it to run.


### Types of queues


1- Async Queues


2- Sync Queues


The most important queue is the mainQueue. This one must not use


- Create a closure (make one or use existed ones)


I need more to practice it.
