import os.path
import time

from thrift.protocol import TJSONProtocol, TBinaryProtocol
from thrift.transport.TTransport import TTransportBase
from werkzeug.serving import run_simple
from werkzeug.wrappers import Request, Response

from api.test import BulletinBoard
from api.test.ttypes import Message, MessageExistsException


class Service(object):
    _instance = None
    def __init__(self, *args, **kwargs):
        self.__class__._instance = self
    @classmethod
    def Get(cls, *args, **kwargs):
        """Service Factory that returns a singleton instance"""
        if not cls._instance:
            cls._instance = cls(*args, **kwargs)
        return cls._instance

class BulletinBoardService(Service, BulletinBoard.Iface):
    """Implments the BulletinBoard Service"""
    messages = []
    def add(self, message):
        time.sleep(10)
        if message in self.messages:
            raise MessageExistsException("This message exists")
        self.messages.append(message)
    def get(self):
        return self.messages


class TIOStreamTransport(TTransportBase):
    """Creates a Thrift Transport from a stream-like object"""
    def __init__(self, input_stream, output_stream):
        self.input_stream = input_stream
        self.output_stream = output_stream

    def isOpen(self):
        return True

    def close(self):
        pass

    def read(self, sz):
        s = self.input_stream.read(sz)
        print s.encode('hex_codec'),
        return s

    def write(self, buf):
        self.output_stream.write(buf)

    def flush(self):
        pass


class ThriftMiddleware(object):
    """Implements a WSGI middleware for handling Thrift services.

    Initialize with a WSGI application (such as a Flask or Django app) and
    a dict of Path -> Handler mappings. ThriftMiddleware will use the
    content-type of the request to determine the thrift protocol
    to use (ie. JSON or Binary).
    """

    def __init__(self, app):
        # TODO: implement a map of path to handler/processors
        self.app = app
        self.bb_handler = BulletinBoardService.Get()
        self.bb_processor = BulletinBoard.Processor(self.bb_handler)

    def __call__(self, environ, start_response):
        path = environ.get('PATH_INFO') or '/'
        method = environ.get('REQUEST_METHOD')
        request = Request(environ)
        response = Response()

        if method == 'POST': # trap all post requests for example
            content_type_header = request.headers.get('Content-Type')

            if not content_type_header:
                response.status_code = 405
                return response(environ, start_response)

            transport = TIOStreamTransport(request.stream, response.stream)
            if 'application/x-thrift' in content_type_header:
                protocol = TBinaryProtocol.TBinaryProtocol(transport)
            elif 'application/json' in content_type_header:
                protocol = TJSONProtocol.TJSONProtocol(transport)
            else:
                response.status_code = 405
                return response(environ, start_response)

            self.bb_processor.process(protocol, protocol)
            return response(environ, start_response)
        else:
            return self.app(environ, start_response)

def test_app(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/plain')])
    return ['Hello World!']

if __name__ == '__main__':
    application = ThriftMiddleware(test_app)
    run_simple('127.0.0.1', 5000, application)
