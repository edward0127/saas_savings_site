class PagesController < ApplicationController
  FAQ_ITEMS = [
    {
      question: "How quickly can we get started?",
      answer: "After your enquiry, we move quickly into a plain-English scope review. Build timing depends on project size and requirements."
    },
    {
      question: "Do you support charities and non-profits?",
      answer: "Yes. We reserve capacity for pro-bono or heavily discounted work for verified charities and non-profits. Support level depends on scope, urgency, and current capacity."
    },
    {
      question: "Can you build for non-technical business owners?",
      answer: "Yes. We explain everything in plain language and keep the process simple from start to launch."
    },
    {
      question: "Do you only replace SaaS tools?",
      answer: "No. We also build new websites and apps, or improve your existing ones. SaaS replacement is just one part of what we do."
    },
    {
      question: "Why is your pricing lower than many agencies?",
      answer: "AI helps us deliver faster. We use that speed to keep projects affordable instead of keeping old high-price delivery models."
    },
    {
      question: "Can you beat another software company quote?",
      answer: "If you share a comparable written quote (same scope, quality, and timeline), we can review it and often provide a lower-cost or higher-value option. It is not a blanket guarantee for every project."
    },
    {
      question: "Do you guarantee exact savings or business results?",
      answer: "No one can guarantee outcomes for every business. We share realistic estimates and examples, and final results depend on your setup and adoption."
    },
    {
      question: "Can we keep tools that already work well?",
      answer: "Absolutely. We keep systems that are mission-critical or compliance-heavy and build around them."
    }
  ].freeze

  def home
    set_meta(
      title: "Tudouke | Fast, Affordable AI-Assisted Websites and Apps",
      description: "Tudouke helps small businesses and individuals worldwide launch websites and apps faster with AI-assisted delivery and experienced quality checks.",
      structured_data: home_structured_data
    )

    @lead = Lead.new(source_page: request.path)
    @process_steps = [
      {
        title: "Tell me what you need",
        detail: "Share your idea, pain point, or current manual process."
      },
      {
        title: "Get a free project plan",
        detail: "I'll help map out a practical solution, including what should be built first."
      },
      {
        title: "Build fast with AI + expert oversight",
        detail: "AI speeds up the heavy lifting, while I review, refine, and shape the result."
      },
      {
        title: "Launch something useful",
        detail: "You get a working digital solution designed to save time, reduce friction, or improve how things run."
      }
    ]
  end

  def how_it_works
    set_meta(
      title: "How It Works | Tudouke",
      description: "A clear 4-step process: tell me what you need, get a free project plan, build fast with AI and expert oversight, then launch something useful."
    )
  end

  def faq
    set_meta(
      title: "FAQ | Tudouke",
      description: "Common questions about Tudouke delivery, pricing approach, timelines, and support.",
      structured_data: faq_structured_data
    )

    @faq_items = FAQ_ITEMS
  end

  def what_we_replace
    set_meta(
      title: "What We Build | Tudouke",
      description: "We build or improve websites and business apps, and only replace software where it makes practical sense."
    )

    @replace_candidates = [
      "New business websites with modern forms, booking, and lead capture",
      "Custom internal tools for approvals and team workflows",
      "Client portals and simple dashboards",
      "Modern rebuilds of slow or outdated websites",
      "Targeted SaaS replacement for overkill tools"
    ]
    @keep_candidates = [
      "Compliance-heavy or regulated systems",
      "Core platforms that already deliver clear business value",
      "Security-critical identity and payment systems"
    ]
  end

  def pricing
    set_meta(
      title: "Engagement Options | Tudouke",
      description: "Flexible, case-by-case project proposals for affordable website and app delivery with AI-assisted workflows."
    )
  end

  def case_studies
    set_meta(
      title: "Case Studies | Tudouke (Coming Soon)",
      description: "Verified case studies are being prepared and will be published after client approval.",
      robots: "noindex,follow"
    )
  end

  def about
    set_meta(
      title: "About | Tudouke",
      description: "Tudouke helps non-technical businesses and individuals access practical AI-assisted software delivery at fair cost."
    )
  end

  def contact
    set_meta(
      title: "Contact | Talk to Tudouke",
      description: "Tell us what you need and we will send a clear project plan in plain language.",
      structured_data: contact_structured_data
    )

    @lead = Lead.new(source_page: request.path)
  end

  def privacy
    set_meta(
      title: "Privacy Policy | Tudouke",
      description: "How Tudouke collects, uses, and protects personal information."
    )
  end

  def terms
    set_meta(
      title: "Terms of Service | Tudouke",
      description: "Terms that apply to website use and service engagement with Tudouke."
    )
  end

  private

  def home_structured_data
    [
      {
        "@context": "https://schema.org",
        "@type": "Service",
        name: "AI-Assisted Website and App Development",
        provider: {
          "@type": "Organization",
          name: "Tudouke",
          url: request.base_url
        },
        areaServed: "Worldwide",
        serviceType: [
          "Website development",
          "Web app development",
          "Workflow automation",
          "Legacy software improvement"
        ],
        audience: {
          "@type": "Audience",
          audienceType: "Small businesses and non-technical individuals"
        }
      }
    ]
  end

  def faq_structured_data
    [
      {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        mainEntity: FAQ_ITEMS.map do |item|
          {
            "@type": "Question",
            name: item[:question],
            acceptedAnswer: {
              "@type": "Answer",
              text: item[:answer]
            }
          }
        end
      }
    ]
  end

  def contact_structured_data
    [
      {
        "@context": "https://schema.org",
        "@type": "ContactPage",
        name: "Contact Tudouke",
        url: "#{request.base_url}#{contact_path}",
        description: "Contact form for website and app project enquiries."
      }
    ]
  end
end
