/*
 * Copyright 2006-2008 The FLWOR Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef ZORBA_GRAPHVIZMODULE_GRAPHVIZ_H
#define ZORBA_GRAPHVIZMODULE_GRAPHVIZ_H

#include <map>

#include <zorba/iterator.h>
#include <zorba/zorba.h>
#include <zorba/function.h>
#include <zorba/external_module.h>

namespace zorba
{
  namespace graphvizmodule
  {
    class GraphvizModule;
/******************************************************************************
 *****************************************************************************/
class GraphvizFunction : public ContextualExternalFunction
{
  protected:
    const GraphvizModule* theModule;

    GraphvizFunction(const GraphvizModule* aModule)
    : theModule(aModule) {}

    static std::string
    getGraphvizTmpFileName(const zorba::DynamicContext*  aDctx);

    static bool
    getAttribute(zorba::ItemFactory* aFactory,
        const char* attrname,
        const zorba::Item& elem,
        zorba::Item& attr);

    static void
    printTypeAndAttr(const zorba::DynamicContext*  aDctx,
                     zorba::ItemFactory* aFactory,
                     const zorba::Item& in,
                     std::fstream& os);

    static void
    visitNode(const zorba::DynamicContext*  aDctx,
              zorba::ItemFactory* aFactory,
              const zorba::Item& in, std::fstream& os);

    static void
    visitEdge(const zorba::DynamicContext*  aDctx,
              zorba::ItemFactory* aFactory,
              const zorba::Item& in, std::fstream& os);

    static void
    printGraph(const zorba::DynamicContext*  aDctx,
               zorba::ItemFactory* aFactory,
               const zorba::Item& in, std::fstream& os);

    static void
    gxl2dot(const zorba::DynamicContext*  aDctx,
            zorba::ItemFactory* aFactory,
            const zorba::Item& in, std::fstream& os);

    static void
    throwErrorWithQName (const DynamicContext* aDynamicContext,
                         const String& aLocalName,
                         const String& aMessage);

  public:

    virtual String
    getURI() const;
};

/******************************************************************************
 *****************************************************************************/
class DotFunction : public GraphvizFunction
{
public:
  DotFunction(const GraphvizModule* aModule)
    : GraphvizFunction(aModule) {}

  virtual ~DotFunction() {}

  virtual String
  getLocalName() const { return "dot"; }

  virtual zorba::ItemSequence_t
  evaluate(const Arguments_t&,
           const zorba::StaticContext*,
           const zorba::DynamicContext*) const;

protected:
  class LazyDotSequence : public zorba::ItemSequence
  {
    class InternalIterator : public Iterator
    {
    private:
      LazyDotSequence   *theItemSequence;
      Iterator_t        arg_iter;
      bool is_open;
    public:
      InternalIterator(LazyDotSequence *item_sequence);

      virtual void open();
      virtual bool next(Item& aItem);
      virtual void close();
      virtual bool isOpen() const;
    };
    public:
      LazyDotSequence(const DotFunction*,
                      ItemSequence* aArg,
                      const zorba::DynamicContext*  aDctx);

      virtual Iterator_t    getIterator();

      const zorba::DynamicContext* getDctx() {return theDctx;};

    protected:
      const DotFunction*            theFunc;
      ItemSequence*                 theArg;
      const zorba::DynamicContext*  theDctx;
  };
};

/******************************************************************************
 *****************************************************************************/
class GxlFunction : public GraphvizFunction
{
public:
  GxlFunction(const GraphvizModule* aModule)
    : GraphvizFunction(aModule) {}

  virtual ~GxlFunction() {}

  virtual String
  getLocalName() const { return "gxl"; }

  virtual zorba::ItemSequence_t
  evaluate(const Arguments_t&,
           const zorba::StaticContext*,
           const zorba::DynamicContext*) const;

protected:
  class LazyGxlSequence : public zorba::ItemSequence
  {
    class InternalIterator : public Iterator
    {
    private:
      LazyGxlSequence   *theItemSequence;
      Iterator_t        arg_iter;
      bool is_open;
    public:
      InternalIterator(LazyGxlSequence *item_sequence);

      virtual void open();
      virtual bool next(Item& aItem);
      virtual void close();
      virtual bool isOpen() const;
    };
    public:
      LazyGxlSequence(const GxlFunction*,
                      ItemSequence* aArg,
                      const zorba::DynamicContext*  aDctx);

      Iterator_t  getIterator();

      const zorba::DynamicContext* getDctx() {return theDctx;};

    protected:
      const GxlFunction*            theFunc;
      ItemSequence*                 theArg;
      const zorba::DynamicContext*  theDctx;
  };
};

/******************************************************************************
 ******************************************************************************/
class GraphvizModule : public ExternalModule
{
private:
  static ItemFactory* theFactory;

protected:
  class ltstr
  {
  public:
	

    bool operator()(const String& s1, const String& s2) const
    {
      return s1.compare(s2) < 0;
    }
  };

  typedef std::map<String, ExternalFunction*, ltstr> FuncMap_t;

  FuncMap_t theFunctions;

public:

	static const char* theModule;

  virtual ~GraphvizModule();

  virtual String
  getURI() const
  {
    return theModule;
  }

  virtual ExternalFunction*
  getExternalFunction(const String& aLocalname);

  virtual void
  destroy();

  static ItemFactory*
  getItemFactory()
  {
    if(!theFactory)
    {
      theFactory = Zorba::getInstance(0)->getItemFactory();
    }
    return theFactory;
  }
};

  } /* namespace zorba */
} /* namespace graphvizmodule */

#endif
