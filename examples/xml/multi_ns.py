
import logging
logging.basicConfig(level=logging.DEBUG)

from spyne import ComplexModel, ServiceBase, rpc, Unicode, Integer32, \
    Application
from spyne.protocol.soap import Soap11
from spyne.server.wsgi import WsgiApplication
from spyne.util.cherry import cherry_graft_and_start


class SomeComplexWithoutNs(ComplexModel):
    s = Unicode
    i = Integer32


class SomeComplexWithNs(ComplexModel):
    __namespace__ = 'http://spyne.io/some-other-tns'

    s = Unicode
    i = Integer32


class SomeService(ServiceBase):
    @rpc(Integer32)
    def some_call_in_app_ns(self, i):
        pass

    @rpc(SomeComplexWithoutNs, _body_style='bare')
    def some_bare_call(self, req):
        pass

    @rpc(SomeComplexWithNs, _body_style='bare')
    def some_call_in_other_ns(self, req):
        pass


application = Application([SomeService], 'http://spyne.io/some-tns',
    in_protocol=Soap11(validator='lxml'),
    out_protocol=Soap11(), multi_ns=True,
)


if  __name__ == "__main__":
    import sys

    sys.exit(cherry_graft_and_start(WsgiApplication(application)))
