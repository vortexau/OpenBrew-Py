
import os

class FermentControl:

    THREADS = 3

    def __init__(self):
        print("OpenBrew - Ferment")


    def run(self):
        print("Running...")

        children = []

        for process in range(self.THREADS):
            pid = os.fork()
            if pid:
                children.append(pid)
            else:
                self.runFermentThread(process, pid)
                os._exit(0)

        for i, child in enumerate(children):
            os.waitpid(child, 0)


    def runFermentThread(self, process, pid):
        print 'This is process thread {0}, with PID {1} for fermenter tasks'.format(process, pid)

